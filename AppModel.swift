/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI
import Vision
import CoreML
import Combine

final class AppModel: ObservableObject {
    let camera = MLCamera()
    let predictionTimer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    @Published var currentMLModel: HandPoseMLModel? {
        didSet {
            guard let model = currentMLModel else { return }
            camera.mlDelegate?.updateMLModel(with: model)
        }
    }
    
    @Published var nodePoints: [CGPoint] = []
    @Published var isHandInFrame: Bool = false
    @Published var predictionLabel: String = ""
    @Published var predictionChance: Double = 0
    @Published var predictionProbability = PredictionMetrics()
    @Published var canPredict: Bool = true
    @Published var isGatheringObservations: Bool = true
    @Published var viewfinderImage: Image?
    @Published var shouldPauseCamera: Bool = false {
        didSet {
            if shouldPauseCamera {
                camera.stop()
                isGatheringObservations = false
            } else {
                Task {
                    await camera.start()
                }
            }
        }
    }

    // Sentence construction support
    @Published var recognizedText: String = ""
    private var lastConfirmedLabel: String = ""
    private var lastPredictionTime: Date = .now

    // How long a sign must persist before being accepted (in seconds)
    private let confirmationDelay: TimeInterval = 1.5

    init() {
        camera.mlDelegate = self
        
        guard let url = Bundle.main.url(forResource: "ASLAlphabetClassifier", withExtension: "mlmodelc"),
              let mlModel = try? MLModel(contentsOf: url) else {
            print("❌ Failed to load ASLAlphabetClassifier.mlmodelc")
            currentMLModel = nil
            return
        }
        currentMLModel = HandPoseMLModel(name: "ASLAlphabetClassifier", mlModel: mlModel, url: url)
        
        Task {
            await camera.start()
            canPredict = true
            await handleCameraPreviews()
        }
    }

    private func handleCameraPreviews() async {
        for await frame in camera.previewStream {
            let image = frame.image
            await MainActor.run {
                self.viewfinderImage = image
            }
        }
    }

    // MARK: - Sentence Logic
    private func confirmPrediction(_ label: String) {
        if label != lastConfirmedLabel {
            lastConfirmedLabel = label
            lastPredictionTime = .now
            return
        }

        // If prediction has been stable for long enough, accept it
        if Date().timeIntervalSince(lastPredictionTime) >= confirmationDelay {
            if label == "space" {
                recognizedText += " "
            } else if label == "del" {
                recognizedText = String(recognizedText.dropLast())
            } else {
                recognizedText += label
            }

            lastConfirmedLabel = "" // reset to prevent double-adding
        }
    }
}

extension AppModel: MLDelegate {
    func updateMLModel(with model: NSObject) {
        guard let mlModel = model as? HandPoseMLModel else { return }
        camera.currentMLModel = mlModel
    }

    @MainActor
    func gatherObservations(pixelBuffer: CVImageBuffer) async {
        guard canPredict else { return }

        canPredict = false

        guard let mlModel = camera.currentMLModel else {
            resetPrediction()
            canPredict = true
            return
        }

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
        do {
            try imageRequestHandler.perform([camera.handPoseRequest])
            guard let observation = camera.handPoseRequest.results?.first else {
                resetPrediction()
                canPredict = true
                return
            }

            isHandInFrame = true
            isGatheringObservations = true

            let poseMultiArray = try observation.keypointsMultiArray()
            let input = HandPoseInput(poses: poseMultiArray)

            guard let output = try mlModel.predict(poses: input) else { return }

            updatePredictions(output: output)

            let jointPoints = try gatherHandPosePoints(from: observation)
            updateNodes(points: jointPoints)

            // Trigger sentence assembly
            if output.label != "Nothing", let prob = output.labelProbabilities[output.label], prob > 0.90 {
                confirmPrediction(output.label)
            }

        } catch {
            print("Error performing request: \(error)")
        }

        canPredict = true
    }

    private func gatherHandPosePoints(from observation: VNHumanHandPoseObservation) throws -> [CGPoint] {
        let allPointsDict = try observation.recognizedPoints(.all)
        return allPointsDict.values.filter { $0.confidence > 0.5 }.map { $0.location }
    }

    @MainActor
    private func updateNodes(points: [CGPoint]) {
        self.nodePoints = points
    }

    @MainActor
    private func updatePredictions(output: HandPoseOutput) {
        predictionLabel = output.label.capitalized
        predictionChance = output.labelProbabilities[output.label] ?? 0
        predictionProbability.getNewPredictions(from: output.labelProbabilities)
    }

    @MainActor
    private func resetPrediction() {
        nodePoints = []
        predictionLabel = ""
        predictionChance = 0
        predictionProbability = PredictionMetrics()
        isHandInFrame = false
    }
}


fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}


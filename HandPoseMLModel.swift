/*
See the License.txt file for this sample’s licensing information.
*/

import Foundation
import CoreML
//import Combine

final class HandPoseMLModel: NSObject, Identifiable {
    let name: String
    let mlModel: MLModel
    let url: URL
    
    private var classLabels: [Any] {
        mlModel.modelDescription.classLabels ?? []
    }

    init(name: String, mlModel: MLModel, url: URL) {
        self.name = name
        self.mlModel = mlModel
        self.url = url
    }

    func predict(poses: HandPoseInput) throws -> HandPoseOutput? {
        let features = try mlModel.prediction(from: poses as MLFeatureProvider)
        let output = HandPoseOutput(features: features)
        return output
    }
}

class HandPoseInput {
    var poses: MLMultiArray
    
    init(poses: MLMultiArray) {
        self.poses = poses
    }
}

extension HandPoseInput: MLFeatureProvider {
    var featureNames: Set<String> {
        get {
            return ["poses"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if featureName == "poses" {
            return MLFeatureValue(multiArray: poses)
        }
        return nil
    }
    
}

class HandPoseOutput {
    let provider : MLFeatureProvider

    lazy var labelProbabilities: [String : Double] = { [unowned self] in
        self.getOutputProbabilities()
    }()

    lazy var label: String = { [unowned self] in
        self.getOutputLabel()
    }()

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}

extension HandPoseOutput {
    func getOutputProbabilities() -> [String : Double] {
        return self.provider.featureValue(for: "labelProbabilities")?.dictionaryValue as? [String : Double] ?? [:]
    }
    
    func getOutputLabel() -> String {
        return self.provider.featureValue(for: "label")?.stringValue ?? ""
    }
}

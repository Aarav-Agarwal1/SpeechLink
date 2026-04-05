/*
See the License.txt file for this sample’s licensing information.
*/

import AVFoundation
import CoreImage
import UIKit
import os.log

class Camera: NSObject {
    private let captureSession = AVCaptureSession()
    private var isCaptureSessionConfigured = false
    private var deviceInput: AVCaptureDeviceInput?
    private var photoOutput: AVCapturePhotoOutput?
    private var videoOutput: AVCaptureVideoDataOutput?
    private var sessionQueue: DispatchQueue!
    
    private var allCaptureDevices: [AVCaptureDevice] {
        AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInDualWideCamera, .builtInWideAngleCamera, .builtInUltraWideCamera], mediaType: .video, position: .unspecified).devices
    }
    
    private var frontCaptureDevices: [AVCaptureDevice] {
        allCaptureDevices
            .filter { $0.position == .front }
    }
    
    private var backCaptureDevices: [AVCaptureDevice] {
        allCaptureDevices
            .filter { $0.position == .back }
    }
    
    private var captureDevices: [AVCaptureDevice] {
        var devices = [AVCaptureDevice]()
        #if os(macOS) || (os(iOS) && targetEnvironment(macCatalyst))
        devices += allCaptureDevices
        #else
        if let frontDevice = frontCaptureDevices.first {
            devices += [frontDevice]
        }
        if let backDevice = backCaptureDevices.first {
            devices += [backDevice]
        }
        #endif
        return devices
    }
    
    private var availableCaptureDevices: [AVCaptureDevice] {
        captureDevices
            .filter( { $0.isConnected } )
            .filter( { !$0.isSuspended } )
    }
    
    private var captureDevice: AVCaptureDevice? {
        didSet {
            guard let captureDevice = captureDevice else { return }
            //logger.debug("Using capture device: \(captureDevice.localizedName)")
            updateSessionForCaptureDevice(captureDevice)
        }
    }
    
    var isRunning: Bool {
        captureSession.isRunning
    }
    
    var isUsingFrontCaptureDevice: Bool {
        guard let captureDevice = captureDevice else { return false }
        return frontCaptureDevices.contains(captureDevice)
    }
    
    var isUsingBackCaptureDevice: Bool {
        guard let captureDevice = captureDevice else { return false }
        return backCaptureDevices.contains(captureDevice)
    }

    private var addToPhotoStream: ((AVCapturePhoto) -> Void)?
    
    private var addToPreviewStream: ((CIImage) -> Void)?
    
    var isPreviewPaused = false
    
    // Provide a context-driven screen to avoid using deprecated UIScreen.main
    weak var screen: UIScreen?
    
    lazy var previewStream: AsyncStream<CIImage> = {
        AsyncStream { continuation in
            addToPreviewStream = { ciImage in
                if !self.isPreviewPaused {
                    continuation.yield(ciImage)
                }
            }
        }
    }()
    
    lazy var photoStream: AsyncStream<AVCapturePhoto> = {
        AsyncStream { continuation in
            addToPhotoStream = { photo in
                continuation.yield(photo)
            }
        }
    }()
    
    var mlDelegate: MLDelegate?
    var previewImageSize: CGSize = .zero

    override init() {
        super.init()
        initialize()
    }
    
    private func initialize() {
        sessionQueue = DispatchQueue(label: "session queue")
                
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(updateForDeviceOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func configureCaptureSession(completionHandler: (_ success: Bool) -> Void) {
        
        var success = false
        
        self.captureSession.beginConfiguration()
        
        defer {
            self.captureSession.commitConfiguration()
            completionHandler(success)
        }
        
        guard
            let captureDevice = captureDevice,
            let deviceInput = try? AVCaptureDeviceInput(device: captureDevice)
        else {
            logger.error("Failed to obtain video input.")
            return
        }
        
        let photoOutput = AVCapturePhotoOutput()
                        
        captureSession.sessionPreset = AVCaptureSession.Preset.photo

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoDataOutputQueue"))
  
        guard captureSession.canAddInput(deviceInput) else {
            logger.error("Unable to add device input to capture session.")
            return
        }
        guard captureSession.canAddOutput(photoOutput) else {
            logger.error("Unable to add photo output to capture session.")
            return
        }
        guard captureSession.canAddOutput(videoOutput) else {
            logger.error("Unable to add video output to capture session.")
            return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(photoOutput)
        captureSession.addOutput(videoOutput)
        
        self.deviceInput = deviceInput
        self.photoOutput = photoOutput
        self.videoOutput = videoOutput
        
        photoOutput.maxPhotoQualityPrioritization = .quality

        if #available(iOS 17.0, *) {
            // pick the largest supported max photo dimensions for the current device active format
            if let device = self.deviceInput?.device {
                let supported = device.activeFormat.supportedMaxPhotoDimensions
                if let largest = supported.max(by: { Int($0.width) * Int($0.height) < Int($1.width) * Int($1.height) }) {
                    // this property exists in iOS 17+: set the photoOutput max dimensions
                    photoOutput.maxPhotoDimensions = largest
                }
            }
        } else {
            // older SDKs - fall back to the old boolean (if available)
            photoOutput.isHighResolutionCaptureEnabled = true
        }
        
        
        updateVideoOutputConnection()
        
        isCaptureSessionConfigured = true
        
        success = true
    }
    
    private func checkAuthorization() async -> Bool {
        //print("[Camera] Checking camera authorization status...")
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            //print("[Camera] Authorization is .authorized")
            logger.debug("Camera access authorized.")
            return true
        case .notDetermined:
            //print("[Camera] Authorization is .notDetermined")
            logger.debug("Camera access not determined.")
            sessionQueue.suspend()
            let status = await AVCaptureDevice.requestAccess(for: .video)
            sessionQueue.resume()
            return status
        case .denied:
            //print("[Camera] Authorization is .denied")
            logger.debug("Camera access denied.")
            return false
        case .restricted:
            //print("[Camera] Authorization is .restricted")
            logger.debug("Camera library access restricted.")
            return false
        @unknown default:
            //print("[Camera] Authorization is unknown")
            return false
        }
    }
    
    private func deviceInputFor(device: AVCaptureDevice?) -> AVCaptureDeviceInput? {
        guard let validDevice = device else { return nil }
        do {
            return try AVCaptureDeviceInput(device: validDevice)
        } catch let error {
            logger.error("Error getting capture device input: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func updateSessionForCaptureDevice(_ captureDevice: AVCaptureDevice) {
        guard isCaptureSessionConfigured else { return }
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        for input in captureSession.inputs {
            if let deviceInput = input as? AVCaptureDeviceInput {
                captureSession.removeInput(deviceInput)
            }
        }
        
        if let deviceInput = deviceInputFor(device: captureDevice) {
            if !captureSession.inputs.contains(deviceInput), captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
        }
        
        updateVideoOutputConnection()
    }
    
    private func updateVideoOutputConnection() {
        if let videoOutput = videoOutput, let videoOutputConnection = videoOutput.connection(with: .video) {
            if videoOutputConnection.isVideoMirroringSupported {
                videoOutputConnection.isVideoMirrored = isUsingFrontCaptureDevice
            }
        }
    }
    
    func start() async {
        //print("[Camera] start() called.")
        let authorized = await checkAuthorization()
        //print("[Camera] Authorization result: \(authorized)")
        guard authorized else {
            logger.error("Camera access was not authorized.")
            return
        }
        
        if isCaptureSessionConfigured {
            if !captureSession.isRunning {
                sessionQueue.async { [self] in
                    self.captureSession.startRunning()
                    //print("[Camera] captureSession.startRunning() called")
                }
            }
            return
        }
        
        sessionQueue.async { [self] in
            if captureDevice == nil {
                captureDevice = availableCaptureDevices.first ?? AVCaptureDevice.default(for: .video)
            }

            self.configureCaptureSession { success in
                guard success else { return }
                self.captureSession.startRunning()
                //print("[Camera] captureSession.startRunning() called")
            }
        }
    }
    
    func stop() {
        guard isCaptureSessionConfigured else { return }
        
        if captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func switchCaptureDevice() {
        sessionQueue.async {
            let availableCaptureDevices = self.availableCaptureDevices
            if let captureDevice = self.captureDevice, let index = availableCaptureDevices.firstIndex(of: captureDevice) {
                let nextIndex = (index + 1) % availableCaptureDevices.count
                self.captureDevice = availableCaptureDevices[nextIndex]
            } else {
                self.captureDevice = AVCaptureDevice.default(for: .video)
            }
        }
    }

    private var deviceOrientation: UIDeviceOrientation {
        var orientation = UIDevice.current.orientation
        if orientation == .unknown, let screen = self.screen {
            orientation = screen.orientation
        }
        return orientation
    }
    
    @objc
    func updateForDeviceOrientation() {
        
    }
    
    // Call this from a view or view controller to provide the appropriate screen context.
    func setScreen(_ screen: UIScreen?) {
        self.screen = screen
    }
    
    @available(iOS, deprecated: 17.0, message: "Use AVCaptureDeviceRotationCoordinator instead")
    private func videoOrientationFor(_ deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation? {
        switch deviceOrientation {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeRight
        case .landscapeRight: return .landscapeLeft
        default: return nil
        }
    }
    
    func takePhoto() {
        guard let photoOutput = self.photoOutput else { return }
        
        sessionQueue.async {
            var photoSettings = AVCapturePhotoSettings()

            if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
                photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            }
            
            let isFlashAvailable = self.deviceInput?.device.isFlashAvailable ?? false
            
            if #available(iOS 17.0, *) {
                if let device = self.deviceInput?.device {
                    let supported = device.activeFormat.supportedMaxPhotoDimensions
                    if let largest = supported.max(by: { Int($0.width) * Int($0.height) < Int($1.width) * Int($1.height) }) {
                        photoSettings.maxPhotoDimensions = largest
                    }
                }
            } else {
                photoSettings.isHighResolutionPhotoEnabled = true
            }

            photoSettings.flashMode = isFlashAvailable ? .auto : .off
            if let previewPhotoPixelFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
            }
            photoSettings.photoQualityPrioritization = .balanced
            
            self.configurePhotoOutputOrientation(photoOutput)
            
            Task { @MainActor in
                photoOutput.capturePhoto(with: photoSettings, delegate: self)
            }
        }
    }
    
    private func configurePhotoOutputOrientation(_ photoOutput: AVCapturePhotoOutput) {
        guard let connection = photoOutput.connection(with: .video) else { return }

        if #available(iOS 17.0, *) {
            guard let device = deviceInput?.device else { return }
            let coordinator = AVCaptureDevice.RotationCoordinator(device: device, previewLayer: nil)
            let angle = coordinator.videoRotationAngleForHorizonLevelCapture

            if connection.isVideoRotationAngleSupported(CGFloat(angle)) {
                connection.videoRotationAngle = CGFloat(angle)
            }
        } else {
            if let videoOrientation = videoOrientationFor(deviceOrientation),
               connection.isVideoOrientationSupported {
                connection.videoOrientation = videoOrientation
            }
        }
    }



    
}

extension Camera: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            logger.error("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        addToPhotoStream?(photo)
    }
}

extension Camera: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }
        let rotationCoordiantor = AVCaptureDevice.RotationCoordinator(
            device: captureDevice!,
            previewLayer: nil
        )
        connection.videoRotationAngle = rotationCoordiantor.videoRotationAngleForHorizonLevelCapture

        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        addToPreviewStream?(ciImage)
        previewImageSize = ciImage.extent.size
        
        guard let delegate = mlDelegate else { return }

        Task {
            await delegate.gatherObservations(pixelBuffer: pixelBuffer)
        }
    }
}

fileprivate extension UIScreen {

    var orientation: UIDeviceOrientation {
        let point = coordinateSpace.convert(CGPoint.zero, to: fixedCoordinateSpace)
        if point == CGPoint.zero {
            return .portrait
        } else if point.x != 0 && point.y != 0 {
            return .portraitUpsideDown
        } else if point.x == 0 && point.y != 0 {
            return .landscapeRight //.landscapeLeft
        } else if point.x != 0 && point.y == 0 {
            return .landscapeLeft //.landscapeRight
        } else {
            return .unknown
        }
    }
}

fileprivate let logger = Logger(subsystem: "com.apple.swiftplaygroundscontent.capturingphotos", category: "Camera")

protocol MLDelegate: AnyObject {
    func updateMLModel(with model: NSObject)
    func gatherObservations(pixelBuffer: CVImageBuffer) async
}


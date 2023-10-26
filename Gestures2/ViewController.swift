import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: - Variables
    private var requests = [VNRequest]()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let captureSession = AVCaptureSession()
    
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    private var previousIndexFingerCoordinates: [VNHumanHandPoseObservation.JointName: CGPoint] = [:]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
       super.viewDidLoad()
       setupVision()
       addCameraInput()
       showCameraFeed()
       getCameraFrames()
       
       DispatchQueue.global(qos: .userInitiated).async {
          self.captureSession.startRunning()
       }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.frame
    }
    
    private func setupVision() {
        // Hand pose request
        let handPoseRequest = VNDetectHumanHandPoseRequest { [weak self] request, error in
            guard let observations = request.results as? [VNHumanHandPoseObservation] else {
                return print("Error: \(error?.localizedDescription ?? "unknown error")")
            }
            
            // Print the number of hands detected
            print("Number of hands detected: \(observations.count)")
        }
        handPoseRequest.maximumHandCount = 2
        self.requests.append(handPoseRequest)
    }

    // MARK: - Setup Functions
    private func addCameraInput() {
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .front).devices.first else {
            fatalError("No camera detected. Please use a real camera, not a simulator.")
        }
        
        // ⚠️ You should wrap this in a `do-catch` block, but this will be good enough for the demo.
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        captureSession.addInput(cameraInput)
    }
    
    private func showCameraFeed() {
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
    }
    
    private func getCameraFrames() {
        videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        // You do not want to process the frames on the Main Thread so we offload to another thread
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        
        captureSession.addOutput(videoDataOutput)
        
        guard let connection = videoDataOutput.connection(with: .video), connection.isVideoOrientationSupported else {
            return
        }
        
        connection.videoOrientation = .portrait
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let image = CIImage(cvImageBuffer: pixelBuffer)
        
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        do {
            try handler.perform(self.requests)
        } catch {
            print(error)
        }
    }
}

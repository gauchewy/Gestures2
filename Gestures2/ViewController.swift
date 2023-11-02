import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var selectedOption: SelectedOption?
    let complete: (Bool) -> Void

    init(selectedOption: SelectedOption, completion: @escaping (Bool) -> Void) {
        self.selectedOption = selectedOption
        self.complete = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    // MARK: - Variables
    private var requests = [VNRequest]()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let captureSession = AVCaptureSession()
    private var previousHandPoints = [CGPoint]()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    private var previousIndexFingerCoordinates: [VNHumanHandPoseObservation.JointName: CGPoint] = [:]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Selected option: \(selectedOption?.rawValue ?? "None")")
       
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
        let handPoseRequest = VNDetectHumanHandPoseRequest { [weak self] request, error in
            guard let observations = request.results as? [VNHumanHandPoseObservation] else {
                return print("Error: \(error?.localizedDescription ?? "unknown error")")
            }
            
            // WAVE
            if self?.selectedOption == .wave {
                if observations.count == 2 {
                    DispatchQueue.main.async {
                        
                        self?.complete(true)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        
                        self?.complete(false)
                    }
                }
            }
            
            // BINOCULARS
            if self?.selectedOption == .binoculars {
                if observations.count == 2 {
                    for observation in observations {
                        guard let thumbTip = try? observation.recognizedPoint(.thumbTip),
                              let indexTip = try? observation.recognizedPoint(.indexTip) else {
                            continue
                        }
                        
                        // Calculate the distance between the middle finger PIP of both hands
                        let distance = sqrt(pow(indexTip.location.x - thumbTip.location.x, 2) + pow(indexTip.location.y - thumbTip.location.y, 2))
                        
                        // If the distance is smaller than threshold, it indicates interlaced hands
                        // YOUR_THRESHOLD_FOR_INTERLACE is a specified threshold that you could determine through experimentation
                        if distance < 0.1 {
                            DispatchQueue.main.async {
                                self?.complete(true)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self?.complete(false)
                            }
                        }
                    }
                    
                    
                }
                else {
                    
                    DispatchQueue.main.async {
                        self?.complete(false)
                    }
                }
            }
                        
            
            // HAND CLASP
            if self?.selectedOption == .handClasp {
                
                for observation in observations {
                    guard let thumbTip = try? observation.recognizedPoint(.thumbTip),
                          let indexTip = try? observation.recognizedPoint(.indexTip),
                          let middleTip = try? observation.recognizedPoint(.middleTip),
                          let ringTip = try? observation.recognizedPoint(.ringTip),
                          let littleTip = try? observation.recognizedPoint(.littleTip) else {
                        continue
                    }
                    
                    // Distances calculated directly
                    let thumbIndexDist = sqrt(pow(indexTip.location.x - thumbTip.location.x, 2) + pow(indexTip.location.y - thumbTip.location.y, 2))
                    let thumbMiddleDist = sqrt(pow(middleTip.location.x - thumbTip.location.x, 2) + pow(middleTip.location.y - thumbTip.location.y, 2))
                    let thumbRingDist = sqrt(pow(ringTip.location.x - thumbTip.location.x, 2) + pow(ringTip.location.y - thumbTip.location.y, 2))
                    let thumbLittleDist = sqrt(pow(littleTip.location.x - thumbTip.location.x, 2) + pow(littleTip.location.y - thumbTip.location.y, 2))
                    
                    // Check if all distances are under threshold
                    let distances = [thumbIndexDist, thumbMiddleDist, thumbRingDist, thumbLittleDist]
                    if distances.allSatisfy({ $0 < 0.2 }) {
                        DispatchQueue.main.async {
                            self?.complete(true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.complete(false)
                        }
                    }
                }
            }
        
   
                

            // INTERLACE
            if self?.selectedOption == .interlace {
                if observations.count == 2 {
                    let knuckles: [VNHumanHandPoseObservation.JointName] = [
                        .thumbIP, .indexPIP, .middlePIP, .ringPIP, .littlePIP
                    ]
                    
                    // Check for valid knuckle points for each hand
                    guard let points1 = try? observations[0].recognizedPoints(.all),
                          let points2 = try? observations[1].recognizedPoints(.all) else {
                        DispatchQueue.main.async {
                            self?.complete(false)
                        }
                        return
                    }

                    // Check if most of the knuckles of two hands are close to each other
                    var closeKnuckles = 0
                    for knuckle in knuckles {
                        guard let point1 = points1[knuckle], let point2 = points2[knuckle] else { continue }
                            
                        let distance = sqrt(pow(point1.location.x - point2.location.x, 2)
                                          + pow(point1.location.y - point2.location.y, 2))
                            
                        if distance < 0.4 { // threshold is a predefined distance
                            closeKnuckles += 1
                        }
                    }
                    DispatchQueue.main.async{
                        self?.complete(closeKnuckles >= 4) // expect at least 4 knuckles to be close
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.complete(false)
                    }
                }
            }
          
        }
        self.requests.append(handPoseRequest)
    }
    
    
    // MARK: - Define Hand Gestures Here
  

    // MARK: - Setup Functions
    private func addCameraInput() {
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .front).devices.first else {
            fatalError("No camera detected. Please use a real camera, not a simulator.")
        }

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
    
    private func printExtendedFingers(observation: VNHumanHandPoseObservation, wristLocation: CGPoint) {
        // This dictionary stores the mapping from finger names to their corresponding points
        let fingerJoints: [String: (tip: VNHumanHandPoseObservation.JointName, mcp: VNHumanHandPoseObservation.JointName)] = [
            "Thumb": (tip: .thumbTip, mcp: .thumbIP),
            "Index": (tip: .indexTip, mcp: .indexMCP),
            "Middle": (tip: .middleTip, mcp: .middleMCP),
            "Ring": (tip: .ringTip, mcp: .ringMCP),
            "Little": (tip: .littleTip, mcp: .littleMCP)
        ]

        var output = ""
        for (fingerName, jointNames) in fingerJoints {
            guard let fingerPoints = try? observation.recognizedPoints(.all) else {
                continue
            }
            let extended = isFingerExtended(
                fingerTip: fingerPoints[jointNames.tip],
                fingerPoints: fingerPoints,
                mcpJoint: jointNames.mcp,
                wristLocation: wristLocation
            )
            output += "\(fingerName): \(extended ? "Extended" : "Not Extended"), "
        }
        print(output)
    }
    
    private func isFingerExtended(fingerTip: VNRecognizedPoint?,
                                  fingerPoints: [VNHumanHandPoseObservation.JointName : VNRecognizedPoint],
                                  mcpJoint: VNHumanHandPoseObservation.JointName,
                                  wristLocation: CGPoint) -> Bool {
        // Ensure the fingertip and the MCP joint points are recognized.
        guard let fingerTip = fingerTip,
              let mcpJointPoint = fingerPoints[mcpJoint] else {
            return false
        }

        // Get the locations of the points.
        let fingerPoint = fingerTip.location
        let mcpPoint = mcpJointPoint.location
        
        // Determine vectors from the MCP joint to the fingertip and to the wrist.
        let fingerVector = CGVector(dx: fingerPoint.x - mcpPoint.x, dy: fingerPoint.y - mcpPoint.y)
        let wristVector = CGVector(dx: wristLocation.x - mcpPoint.x, dy: wristLocation.y - mcpPoint.y)
        
        // Calculate the cosine of the angle between the vectors.
        let dotProduct = fingerVector.dx * wristVector.dx + fingerVector.dy * wristVector.dy
        let magnitudeProduct = sqrt(fingerVector.dx * fingerVector.dx + fingerVector.dy * fingerVector.dy) * sqrt(wristVector.dx * wristVector.dx + wristVector.dy * wristVector.dy)
        let cosineAngle = dotProduct / magnitudeProduct

        // Consider the finger as extended if the angle between the vectors is less than 90 degrees.
        if cosineAngle < cos(.pi / 2.0) {
            return true
        }
        
        return false
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

        // Perform the request
        do {
            try handler.perform(requests)
            guard let results = requests.first?.results as? [VNHumanHandPoseObservation] else {
                return
            }

            for observation in results {
                // Get wrist location to pass into printExtendedFingers
                let wristPoints = try observation.recognizedPoints(.all)
                let wristLocation = wristPoints[.wrist]?.location
                if let wristLocation = wristLocation {
                    printExtendedFingers(observation: observation, wristLocation: wristLocation)
                }
            }
        } catch {
            print("Failed to perform Vision request: \(error)")
        }
    }

}

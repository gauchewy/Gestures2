//
//  ViewController.swift
//  Gestures2
//
//  Created by Qiwei on 10/12/23.
//


import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: - Variables
    
    private var numberOfHandsDetected = 0
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let captureSession = AVCaptureSession()
    
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    private var previousIndexFingerCoordinates: [VNHumanHandPoseObservation.JointName: CGPoint] = [:]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
       super.viewDidLoad()
       
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
    
    // MARK: - Helper Functions
    
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
}
    

//
//  VideoRecorder.swift
//  MoveEasy
//
//  Created by Apple on 10/12/1443 AH.
//

import UIKit
import AVFoundation

class VideoRecorder: UIViewController {
    
    private var session: AVCaptureSession?
    private let output: AVCapturePhotoOutput = AVCapturePhotoOutput()
    private let previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    private let captureButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        button.layer.cornerRadius = 35
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        self.modalPresentationStyle = .fullScreen
        view.layer.addSublayer(previewLayer)
        view.addSubview(captureButton)
        
        captureButton.addTarget(self, action: #selector(captureVideo), for: .touchUpInside)
        
        checkCameraPermission()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = view.bounds
        captureButton.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height - 70)
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self.setupCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera()
        @unknown default:
            break
        }
    }
    
    private func setupCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
            } catch {
                print("DEVICE ERROR: ", error)
            }
        }
    }
    
    @objc private func captureVideo() {
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
}

extension VideoRecorder: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("")
    }
}

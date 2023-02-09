//
//  ScannerView.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 08/02/23.
//

import Foundation
import SwiftUI
import AVFoundation

struct ScannerView: UIViewControllerRepresentable {
    
    @ObservedObject var vm: TextRecognizerViewModel
    @Environment(\.presentationMode) private var presentationMode
    var completionHandler: (() -> Void)?
    
    
    init(vm: TextRecognizerViewModel) {
        self.vm = vm
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = ScannerViewController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    final class Coordinator: NSObject, ScannerViewControllerDelegate {
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let imageData = photo.fileDataRepresentation(),
               let image = UIImage(data: imageData) {
                parent.vm.handleImage(image: image)
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        var parent: ScannerView
        
        init(_ parent: ScannerView) {
            self.parent = parent
        }
        
        func didLoad(stopSession: @escaping () -> Void ) {
            parent.completionHandler = stopSession
        }
    }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
}

protocol ScannerViewControllerDelegate {
    func didLoad(stopSession: @escaping () -> Void )
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?)
    
}

class ScannerViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    private let captureSession = AVCaptureSession()
    let captureSessionQueue = DispatchQueue(label: "com.mp.CaptureSessionQueue")
    
    var captureDevice: AVCaptureDevice?
    var captureOutput: AVCapturePhotoOutput!
    var bufferAspectRatio: Double!
    var cameraPreviewLayer : AVCaptureVideoPreviewLayer!
    var delegate : ScannerViewControllerDelegate?
    
    var shutterButton: UIButton!
    
    override func viewDidLoad() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer!.videoGravity = .resizeAspectFill
        cameraPreviewLayer!.connection?.videoOrientation = .portrait
        cameraPreviewLayer.frame = view.frame
        view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(captureImage)))
        self.addShutterButton()
        captureSessionQueue.async {
            self.setupCamera();
        }
        
        delegate?.didLoad(stopSession: stopSession)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        captureSession.stopRunning()
    }
    
    func stopSession() {
        captureSession.stopRunning()
    }
    
    func setupCamera() {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else {
            print("Could not create capture device.")
            return
        }
        self.captureDevice = captureDevice
        captureDevice.supportsSessionPreset(.iFrame960x540)
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("Could not create device input.")
            return
        }
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        }
        
        captureOutput = AVCapturePhotoOutput()
        captureOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
        }
        
        // Set zoom and autofocus to help focus on very small text.
        do {
            try captureDevice.lockForConfiguration()
            captureDevice.videoZoomFactor = 2
            captureDevice.autoFocusRangeRestriction = .near
            captureDevice.unlockForConfiguration()
        } catch {
            print("Could not set zoom level due to error: \(error)")
            return
        }
        
        captureSession.startRunning()
    }
    
    @objc func captureImage() {
        let settings = AVCapturePhotoSettings()
        captureOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        delegate?.photoOutput(output, didFinishProcessingPhoto: photo, error: error)
    }
    
    private func addShutterButton() {
        let width: CGFloat = 60
        let height = width
        shutterButton = UIButton(frame: CGRect(x: (view.frame.width - width) / 2,
                                               y: view.frame.height - height - 100,
                                               width: width,
                                               height: height
                                              )
        )
        shutterButton.layer.cornerRadius = width / 2
        shutterButton.backgroundColor = UIColor.init(displayP3Red: 1, green: 1, blue: 1, alpha: 0.8)
        shutterButton.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        view.addSubview(shutterButton)
    }
}

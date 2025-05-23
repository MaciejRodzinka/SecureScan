import Foundation
import AVFoundation
import UIKit

class QRScannerService: NSObject {
    
    static let shared = QRScannerService()
    
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var qrCodeFrameView: UIView?
    private var scanCompletion: ((String?) -> Void)?
    
    private override init() {
        super.init()
    }
    
    func setupScanner(in view: UIView, completion: @escaping (String?) -> Void) {
        self.scanCompletion = completion
        
        
        videoPreviewLayer?.removeFromSuperlayer()
        qrCodeFrameView?.removeFromSuperview()
        
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { 
            scanningFailed()
            return 
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("Error creating video input: \(error)")
            scanningFailed()
            return
        }
        
        guard let captureSession = captureSession else {
            scanningFailed()
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            scanningFailed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            scanningFailed()
            return
        }
        
        
        let newPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        newPreviewLayer.videoGravity = .resizeAspectFill
        newPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(newPreviewLayer)
        self.videoPreviewLayer = newPreviewLayer
        
        
        let scanFrame = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width * 0.8, height: view.bounds.width * 0.8))
        scanFrame.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        scanFrame.layer.borderColor = UIColor(red: 0.0, green: 0.8, blue: 0.2, alpha: 0.8).cgColor
        scanFrame.layer.borderWidth = 3
        scanFrame.layer.cornerRadius = 10
        
        
        let cornerLength: CGFloat = 20
        let cornerThickness: CGFloat = 5
        
        
        let corners = ["topLeft", "topRight", "bottomLeft", "bottomRight"]
        for corner in corners {
            let cornerView1 = UIView()
            let cornerView2 = UIView()
            
            cornerView1.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.2, alpha: 1.0)
            cornerView2.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.2, alpha: 1.0)
            
            scanFrame.addSubview(cornerView1)
            scanFrame.addSubview(cornerView2)
            
            cornerView1.translatesAutoresizingMaskIntoConstraints = false
            cornerView2.translatesAutoresizingMaskIntoConstraints = false
            
            var constraints = [NSLayoutConstraint]()
            
            switch corner {
            case "topLeft":
                cornerView1.layer.cornerRadius = cornerThickness / 2
                cornerView2.layer.cornerRadius = cornerThickness / 2
                
                constraints = [
                    cornerView1.leftAnchor.constraint(equalTo: scanFrame.leftAnchor),
                    cornerView1.topAnchor.constraint(equalTo: scanFrame.topAnchor),
                    cornerView1.widthAnchor.constraint(equalToConstant: cornerLength),
                    cornerView1.heightAnchor.constraint(equalToConstant: cornerThickness),
                    
                    cornerView2.leftAnchor.constraint(equalTo: scanFrame.leftAnchor),
                    cornerView2.topAnchor.constraint(equalTo: scanFrame.topAnchor),
                    cornerView2.widthAnchor.constraint(equalToConstant: cornerThickness),
                    cornerView2.heightAnchor.constraint(equalToConstant: cornerLength)
                ]
            case "topRight":
                cornerView1.layer.cornerRadius = cornerThickness / 2
                cornerView2.layer.cornerRadius = cornerThickness / 2
                
                constraints = [
                    cornerView1.rightAnchor.constraint(equalTo: scanFrame.rightAnchor),
                    cornerView1.topAnchor.constraint(equalTo: scanFrame.topAnchor),
                    cornerView1.widthAnchor.constraint(equalToConstant: cornerLength),
                    cornerView1.heightAnchor.constraint(equalToConstant: cornerThickness),
                    
                    cornerView2.rightAnchor.constraint(equalTo: scanFrame.rightAnchor),
                    cornerView2.topAnchor.constraint(equalTo: scanFrame.topAnchor),
                    cornerView2.widthAnchor.constraint(equalToConstant: cornerThickness),
                    cornerView2.heightAnchor.constraint(equalToConstant: cornerLength)
                ]
            case "bottomLeft":
                cornerView1.layer.cornerRadius = cornerThickness / 2
                cornerView2.layer.cornerRadius = cornerThickness / 2
                
                constraints = [
                    cornerView1.leftAnchor.constraint(equalTo: scanFrame.leftAnchor),
                    cornerView1.bottomAnchor.constraint(equalTo: scanFrame.bottomAnchor),
                    cornerView1.widthAnchor.constraint(equalToConstant: cornerLength),
                    cornerView1.heightAnchor.constraint(equalToConstant: cornerThickness),
                    
                    cornerView2.leftAnchor.constraint(equalTo: scanFrame.leftAnchor),
                    cornerView2.bottomAnchor.constraint(equalTo: scanFrame.bottomAnchor),
                    cornerView2.widthAnchor.constraint(equalToConstant: cornerThickness),
                    cornerView2.heightAnchor.constraint(equalToConstant: cornerLength)
                ]
            case "bottomRight":
                cornerView1.layer.cornerRadius = cornerThickness / 2
                cornerView2.layer.cornerRadius = cornerThickness / 2
                
                constraints = [
                    cornerView1.rightAnchor.constraint(equalTo: scanFrame.rightAnchor),
                    cornerView1.bottomAnchor.constraint(equalTo: scanFrame.bottomAnchor),
                    cornerView1.widthAnchor.constraint(equalToConstant: cornerLength),
                    cornerView1.heightAnchor.constraint(equalToConstant: cornerThickness),
                    
                    cornerView2.rightAnchor.constraint(equalTo: scanFrame.rightAnchor),
                    cornerView2.bottomAnchor.constraint(equalTo: scanFrame.bottomAnchor),
                    cornerView2.widthAnchor.constraint(equalToConstant: cornerThickness),
                    cornerView2.heightAnchor.constraint(equalToConstant: cornerLength)
                ]
            default:
                break
            }
            
            NSLayoutConstraint.activate(constraints)
        }
        
        view.addSubview(scanFrame)
        self.qrCodeFrameView = scanFrame
        
        
        let scanLine = UIView(frame: CGRect(x: 0, y: 0, width: scanFrame.bounds.width - 10, height: 2))
        scanLine.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.2, alpha: 0.8)
        scanLine.center = CGPoint(x: scanFrame.bounds.width/2, y: 10)
        scanFrame.addSubview(scanLine)
        
        
        UIView.animate(withDuration: 1.5, delay: 0.0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            scanLine.frame.origin.y = scanFrame.bounds.height - 10
        })
    }
    
    func startScanning() {
        if captureSession?.isRunning == false {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.captureSession?.startRunning()
            }
        }
    }
    
    func stopScanning() {
        if captureSession?.isRunning == true {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.captureSession?.stopRunning()
            }
        }
    }
    
    private func scanningFailed() {
        scanCompletion?(nil)
        captureSession = nil
    }
    
    
    func scanQRFromImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let ciImage = CIImage(image: image) else {
            completion(nil)
            return
        }
        
        let context = CIContext()
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
        
        let features = detector?.features(in: ciImage) ?? []
        
        for feature in features as? [CIQRCodeFeature] ?? [] {
            if let messageString = feature.messageString {
                completion(messageString)
                return
            }
        }
        
        completion(nil)
    }
}

extension QRScannerService: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        
        if metadataObjects.isEmpty {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            
            if let videoPreviewLayer = videoPreviewLayer {
                let barCodeObject = videoPreviewLayer.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView?.frame = barCodeObject!.bounds
            }
            
            
            if let stringValue = metadataObj.stringValue {
                
                stopScanning()
                
                
                scanCompletion?(stringValue)
            }
        }
    }
}

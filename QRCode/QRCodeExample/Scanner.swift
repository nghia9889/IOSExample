//
//  ScannerClass.swift
//  QRCodeExample
//
//  Created by Ha Thi Hoan on 10/30/18.
//  Copyright © 2018 Ha Thi Hoan. All rights reserved.
//

import AVFoundation
import UIKit

class Scanner: NSObject {
    private var viewController: ViewController
    private var captureSession: AVCaptureSession?
    private var codeOutputHandler: (_ code: String) -> Void
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    init (withViewController viewController: ViewController, view: UIView, codeOutputHandler: @escaping(String) ->Void) {
        self.viewController = viewController
        self.codeOutputHandler = codeOutputHandler
        super.init()
        if let captureSesion = self.createCaptureSession(){
            self.captureSession = captureSesion
            let previewLayer = self.createPreviewLayer(withCaptureSession: captureSesion, view: view)
            view.layer.addSublayer(previewLayer)
            self.previewLayer = previewLayer
        }
    }
    
    private func createCaptureSession() -> AVCaptureSession? {
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return nil
        }
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            let metaDataOutput = AVCaptureMetadataOutput()
            
            //add device input
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            } else {
                return nil
            }
            
            // add meta output
            if captureSession.canAddOutput(metaDataOutput) {
                captureSession.addOutput(metaDataOutput)
                if let viewController = self.viewController as? AVCaptureMetadataOutputObjectsDelegate {
                    metaDataOutput.setMetadataObjectsDelegate(viewController, queue: DispatchQueue.main)
                    metaDataOutput.metadataObjectTypes = self.metaObjectType()
                }
            } else {
                return nil
            }
            
        } catch {
            return nil
        }
        return captureSession
    }
    
    private func metaObjectType() -> [AVMetadataObject.ObjectType] {
        return [
                .qr,
                .code128,
                .code39,
                .code39Mod43,
                .code93,
                .ean13,
                .ean8,
                .interleaved2of5,
                .itf14,
                .pdf417,
                .upce
        ]
    }
    
    private func createPreviewLayer(withCaptureSession captureSession: AVCaptureSession, view: UIView) -> AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer (session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }
    
    func requestCaptureSessionStartRunning() {
        guard let captureSession = self.captureSession else {
            return
        }
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
       
    }
    
    func requestCaptureSessionStopRunning() {
        guard let captureSession  = self.captureSession else {
            return
        }
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func scannerDelegate(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.requestCaptureSessionStopRunning()
        if let metadataObject = metadataObjects.first {
            guard let reableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
                return
            }
            guard let stringValue = reableObject.stringValue else {
                return
            }
            if let previewLayer = self.previewLayer {
                previewLayer.removeFromSuperlayer()
            }
            self.codeOutputHandler(stringValue)
        }
    }
}

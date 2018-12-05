//
//  ViewController.swift
//  QRCodeExample
//
//  Created by Ha Thi Hoan on 10/30/18.
//  Copyright © 2018 Ha Thi Hoan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var previewQRLabel: UILabel!
    var scanner: Scanner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.scanner = Scanner.init(withViewController: self, view: self.view, codeOutputHandler: { [weak self](codeString) in
            guard let this = self else {
                return
            }
            this.previewQRLabel.text = codeString
        })
    }
    
    @IBAction func qrCodeClick(_ sender: Any) {
        if let scanner = self.scanner {
            scanner.requestCaptureSessionStartRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.scanner?.scannerDelegate(output, didOutput: metadataObjects, from: connection)
    }
    
}


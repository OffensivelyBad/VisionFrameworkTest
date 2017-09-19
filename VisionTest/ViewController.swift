//
//  ViewController.swift
//  VisionTest
//
//  Created by Shawn Roller on 8/16/17.
//  Copyright © 2017 Offensively-Bad. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    // front captured all but 7 (smallest)
    // top captured all 10
    // bottom captured all but 7 (smallest)
    // left captured 5. Did not capture 1, 2, 3, 4, 7
    // right captured all 10
    
    var barcodeRequest = VNDetectBarcodesRequest()
    var imageHandler: VNImageRequestHandler!
    let image = #imageLiteral(resourceName: "rack1")
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.width * 0.66))
        imageView.image = self.image
        imageView.contentMode = .scaleToFill
        self.view.addSubview(imageView)
        
        setupBarcodeRequest()
        
        detectBarcode()
        
    }
    
    func setupBarcodeRequest() {
        self.barcodeRequest = VNDetectBarcodesRequest { (request, error) in
            
            guard let results = request.results else { return }
            for result in results {
                guard let barcode = result as? VNBarcodeObservation else { return }
                print(barcode.payloadStringValue ?? "", terminator: "\n\n")
                
                if let rect = result as? VNRectangleObservation {
                    self.drawTextBox(box: rect)
                }
                
            }
            
        }
        
        
    }
    
    func drawTextBox(box: VNRectangleObservation) {
        let xCoord = box.topLeft.x * self.imageView.frame.size.width
        let yCoord = (1 - box.topLeft.y) * self.imageView.frame.size.height
        let width = (box.topRight.x - box.bottomLeft.x) * self.imageView.frame.size.width
        let height = (box.topLeft.y - box.bottomLeft.y) * self.imageView.frame.size.height
        
        let layer = CALayer()
        layer.borderWidth = 4
        layer.frame = CGRect(x: xCoord - layer.borderWidth, y: yCoord - layer.borderWidth, width: width + layer.borderWidth * 2, height: height + layer.borderWidth * 2)
        layer.borderColor = UIColor.red.cgColor
        
        self.imageView.layer.addSublayer(layer)
    }
    
    func detectBarcode() {
        self.imageHandler = VNImageRequestHandler(cgImage: self.image.cgImage!, options: [.properties : ""])
        do {
            try self.imageHandler.perform([self.barcodeRequest])
        } catch {
            print("could not capture barcode")
        }
    }


}


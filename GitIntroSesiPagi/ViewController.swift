//
//  ViewController.swift
//  GitIntroSesiPagi
//
//  Created by Muhammad Tafani Rabbani on 11/06/21.
//

import UIKit
import Vision

class ViewController: UIViewController {

    
    private let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .red
        return label
    }()
    
    private let image : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "barcodeExample")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(image)
        view.addSubview(label)
        
        label.text = ""
        textRecognition(image: image.image ?? UIImage())
    }

    override func viewDidLayoutSubviews() {
        image.frame = CGRect(x: 20, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: view.frame.size.height/4)
        
        label.frame = CGRect(x: view.center.x, y: view.center.y, width: view.frame.size.width*0.8, height: view.frame.size.height*0.5)
        label.center = view.center
    }
    
    func textRecognition(image : UIImage){
        
        
        
        //prepare CGImage
        guard let cgImage = image.cgImage else {return}
        
        //Prepare the Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        //Prepare the request
        let req = VNRecognizeTextRequest { request, error in
            guard let observation = request.results as? [VNRecognizedTextObservation]
                  ,error == nil else{return}
            
            let list = observation.compactMap{$0.topCandidates(1).first?.string}.joined(separator: ",")
            
            DispatchQueue.main.async {
                self.label.text! += "text : " + list
            }
        }
        
        let req2 = VNDetectBarcodesRequest { request, error in
            guard let observation = request.results as? [VNBarcodeObservation]
                  ,error == nil else{return}
            
            let list = observation.compactMap{$0.payloadStringValue}
                .joined(separator: ",")
            
            DispatchQueue.main.async {
                self.label.text! += "barcode : " + list
            }
        }
        
        //handler perform the request
        do{
            try handler.perform([req2,req])
        }catch{
            print(error)
        }
        
    }
}


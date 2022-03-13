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
        image.image = UIImage(named: "bill")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let textImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let docImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let menu : [String] = ["Blue Flame","First Snow","Kopi Oppa","Spring Day","Mint Choco","Kopi Unnie","Kopi Ahjussi","Kopi Moka","Kopi Churum","Caramel Macchiato","Caramel Latte","Mint Latte","Banana Uyu","Red Flavor","Spring Day","Dark Chocolit","White Regal","Sunny Summer","Lychee Tea","Peach Tea","Cheon Sa Sparkling Drink","Snowy Wish","Chicken Salted Egg Rice Bowl","Cireng","Croffle Single","French Fries","Gimbab","Masshida Hotdog","Spicy Beef Rice Bowl","Nasi Goreng Bulgogi","Nasi Goreng Original","Nasi Putih","Tokkebi of Seoul","Tteokbokki Street Size","Chicken Gangjeong Street Size","Gimmari Stick","Mandu Stick","Tteokkochi Cheese and Sausage","Egg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(image)
        view.addSubview(textImage)
        view.addSubview(docImage)
        view.addSubview(label)
        
        
        label.text = ""
        textRecognition(image: image.image ?? UIImage())
    }

    override func viewDidLayoutSubviews() {
//        image.frame = CGRect(x: 20, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: view.frame.size.height/4)
//
//        label.frame = CGRect(x: view.center.x, y: view.center.y, width: view.frame.size.width*0.8, height: view.frame.size.height*0.5)
        
        image.frame = view.frame
        image.center = view.center
        textImage.frame = view.frame
        textImage.center = view.center
        docImage.frame = view.frame
        docImage.center = view.center
        
        label.center = view.center
    }
    
    var isLookingCode = false
    var code = ""
    var predictedMenus : [String] = []
    
    func textRecognition(image : UIImage){
        
        //prepare CGImage
        guard let cgImage = image.cgImage else {return}
        
        //Prepare the Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        //Prepare the request
        let req = VNRecognizeTextRequest { request, error in
            guard let observation = request.results as? [VNRecognizedTextObservation]
                  ,error == nil else{return}
            
            for currentObservation in observation{
                let topCandidate = currentObservation.topCandidates(1)
                if let recognizedText = topCandidate.first {
                    //OCR Results
                    
                    if self.isLookingCode {
                        self.code = recognizedText.string
                        self.isLookingCode.toggle()
                    }else if recognizedText.string == "Receipt Number" {
                        self.isLookingCode = true
                    }
                    var min = 15
                    var predictedMenu = ""
                    for m in self.menu {
                        
                        if recognizedText.string.levenshtein(m) < (m.count/2) && recognizedText.string != "Kopi Chuseyo"{
                            DispatchQueue.main.async {
//                                print(recognizedText.string,"-",m)
                            }
                            if min > recognizedText.string.levenshtein(m){
                                predictedMenu = m
                                min = recognizedText.string.levenshtein(m)
                            }
                        }
                    }
                    if !predictedMenu.isEmpty{
                        self.predictedMenus.append(predictedMenu)
                    }
                    
                }
            }
            
            
            if #available(iOS 15.0, *) {
                let req2 = VNDetectDocumentSegmentationRequest { request, error in
                    guard let observation2 = request.results as? [VNRectangleObservation]
                            ,error == nil else{return}
                    let result = self.visualization(image, observations: observation, observations2: observation2)
                    DispatchQueue.main.async {
        //                self.label.text! += "text : " + list
                        self.docImage.image = result
                        print(self.code)
                        print(self.predictedMenus)
                    }
                }
                
                do{
                    try handler.perform([req2])
                }catch{
                    print(error)
                }
                
            } else {
                // Fallback on earlier versions
            }
            
        }
        req.recognitionLevel = .accurate
        req.usesLanguageCorrection = true
        
        do{
            try handler.perform([req])
        }catch{
            print(error)
        }
    }
    
    public func visualization(_ image: UIImage, observations: [VNDetectedObjectObservation],observations2: [VNRectangleObservation]) -> UIImage {
        
        var transform = CGAffineTransform.identity
            .scaledBy(x: 1, y: -1)
            .translatedBy(x: 1, y: -image.size.height)
        transform = transform.scaledBy(x: image.size.width, y: image.size.height)

        UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()

        image.draw(in: CGRect(origin: .zero, size: image.size))
        context?.saveGState()

        context?.setLineWidth(2)
        context?.setLineJoin(CGLineJoin.round)
        context?.setStrokeColor(red: 1, green: 0, blue: 0, alpha: 0.3)
        context?.setFillColor(UIColor.red.cgColor)
        
        observations.forEach { observation in
            let bounds = observation.boundingBox.applying(transform)
            context?.addRect(bounds)
        }
        observations2.forEach { observation in
            let bounds = observation.boundingBox.applying(transform)
            context?.addRect(bounds)
        }

        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        context?.restoreGState()
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage!
    }
}


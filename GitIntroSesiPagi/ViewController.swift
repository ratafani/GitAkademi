//
//  ViewController.swift
//  GitIntroSesiPagi
//
//  Created by Muhammad Tafani Rabbani on 11/06/21.
//

import UIKit
import ARKit
import RealityKit
import FocusEntity

class ViewController: UIViewController,ARSessionDelegate{

    @IBOutlet weak var arView: ARView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    var i = 0
    var firstAnchor = SIMD3<Float>()
    var secondAnchor = SIMD3<Float>()
    var listPoints = [SIMD3<Float>]()
    var listMeter = [CGFloat]()
    var arrPoint = [CGPoint]()
    let convex = ConvexHull()
    var distance : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceLabel.text = ""
        startPlaneDetection()
        
        let focusSquare = FocusEntity(on: arView, focus: .classic)
        focusSquare.scale = [0.5,0.5,0.5]
        
        let anchor = AnchorEntity(.camera)
        anchor.addChild(focusSquare)
        arView.scene.addAnchor(anchor)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(recognizer:)))
        
        arView.addGestureRecognizer(tap)
    }
    
    
    @objc func tapGesture(recognizer : UITapGestureRecognizer){
        if recognizer.state != .ended {
            return
        }
        i+=1
        
        guard let result = arView.raycast(from: view.center, allowing: .estimatedPlane, alignment: .horizontal).first else{
            return
        }

        let position = result.worldTransform.simd_position
        var ball = ModelEntity()
        
        if i%2==0{
            ball = crateEntity(color: .green)
        }else{
            ball = crateEntity(color: .red)
        }
        
        let anchor = AnchorEntity(.plane(.horizontal, classification: .floor, minimumBounds: .zero))
        anchor.addChild(ball)
        
        arView.scene.addAnchor(anchor)
        
        listPoints.append(position)
        if i%2 == 1{
            firstAnchor = position
        }else{
            secondAnchor = position
            
            distance = simd_distance(firstAnchor, secondAnchor)
            distance = distance * 100
            listMeter.append(CGFloat(distance))
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.roundingMode = .ceiling
            formatter.maximumFractionDigits = 2
            // Scene units map to meters in ARKit.
         
            distanceLabel.text = "Distance: " + formatter.string(from: NSNumber(value: distance))! + " cm"

        }
        
        if i>2{
            
            for p in listPoints{
                let pin = CGPoint(x: CGFloat(p.x), y: CGFloat(p.z))
                arrPoint.append(pin)
            }
            
            convex.quickHull(points: arrPoint)
    
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.roundingMode = .ceiling
            formatter.maximumFractionDigits = 2
            var area = convex.area()
            area = area * 10000
            
            print(area,convex.area())
            
            distanceLabel.text = "Distance: " + formatter.string(from: NSNumber(value: distance))! + " m" + "\n Area: " + formatter.string(from: NSNumber(value: area))! + " cm2"
            
        }
        
    }
    
    func startPlaneDetection(){
        arView.automaticallyConfigureSession = false
        let config = ARWorldTrackingConfiguration()
        
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic
        
        arView.session.run(config)
    }

    
    func crateEntity(color:UIColor)->ModelEntity{
        let mesh = MeshResource.generateSphere(radius: 0.01)
        
        let material = SimpleMaterial(color: color, roughness: 0, isMetallic: true)
        
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        return entity
    }

}



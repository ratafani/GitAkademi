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
    
    public var focusSquare : FocusEntity!
    var pathEntity : RKPathEntity!
    
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
        
        arView.session.delegate = self
        
//        arView.session.currentFrame?.lightEstimate?.ambientIntensity
        //nilai minimum lux food candle = 1140
        
        
        distanceLabel.text = ""
        startPlaneDetection()
        
        do {
          let onColor: MaterialColorParameter = try .texture(.load(named: "Add"))
          let offColor: MaterialColorParameter = try .texture(.load(named: "Open"))
          self.focusSquare = FocusEntity(
            on: arView,
            style: .colored(
              onColor: onColor, offColor: offColor,
              nonTrackingColor: offColor
            )
          )
        } catch {
            self.focusSquare = FocusEntity(on: arView, focus: .classic)
          print("Unable to load plane textures")
          print(error.localizedDescription)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(recognizer:)))
        
        arView.addGestureRecognizer(tap)
    }
    
    
    @objc func tapGesture(recognizer : UITapGestureRecognizer){
        if let path = pathEntity {
            self.arView.scene.removeAnchor(path)
        }
        
        if recognizer.state != .ended {
            return
        }
        i+=1

        let position = self.focusSquare.position(relativeTo: nil)
        var ball = ModelEntity()
        
        if i%2==0{
            ball = crateEntity(color: .green)
        }else{
            ball = crateEntity(color: .red)
        }
        pathEntity = RKPathEntity(arView: arView,
                                      path: listPoints,
                                     width: 0.001,
                                      materials: [UnlitMaterial.init(color: .green)])
        
        let anchor = AnchorEntity(world: focusSquare.position)
//        let anchor = AnchorEntity(
//        let anchor = AnchorEntity(.pl)
        anchor.addChild(ball)
        
        pathEntity.pathPoints.append(position)
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
            
            distanceLabel.text = "Distance: " + formatter.string(from: NSNumber(value: distance))! + " cm" + "\n Area: " + formatter.string(from: NSNumber(value: area))! + " cm2"
            
        }
        
    }
    
    func startPlaneDetection(){
        
        if #available(iOS 13.4, *),
            ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal
            configuration.sceneReconstruction = .meshWithClassification
            arView.session.run(configuration)
            
            //Allows objects to be occluded by the sceneMesh.
            arView.environment.sceneUnderstanding.options.insert(.occlusion)
            
            //show colored mesh.
            //self.arView.debugOptions.insert(.showSceneUnderstanding)
        } else{
            
            arView.automaticallyConfigureSession = false
            let config = ARWorldTrackingConfiguration()
            
            config.planeDetection = [.horizontal]
            config.environmentTexturing = .automatic
            
            arView.session.run(config)
        }
    }

    
    func crateEntity(color:UIColor)->ModelEntity{
        let mesh = MeshResource.generateSphere(radius: 0.01)
        
        let material = SimpleMaterial(color: color, roughness: 0, isMetallic: true)
        
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        return entity
    }

    
    
    //delegate add anchor
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        if let planeAnchor = anchors.first as? ARPlaneAnchor,
           planeAnchor.alignment == .vertical{
            
            //To make the mesh more precise, we could create an SCNScene from this geometry, save it to disk - converting it to usdz
            //and then load it as a RealityKit entity and assign it an occlusion material.
            
            //using generatedPlane didn't work.
            //let mesh = MeshResource.generatePlane(width: planeAnchor.extent.x, depth: planeAnchor.extent.y)
            let mesh = MeshResource.generateBox(size: [planeAnchor.extent.x,
                                                       planeAnchor.extent.y,
                                                       planeAnchor.extent.z])
            let occlusionPlane = ModelEntity(mesh: mesh,
                                             materials: [OcclusionMaterial()])
            let planeAnchor = AnchorEntity(anchor: planeAnchor)
            arView.scene.addAnchor(planeAnchor)
            planeAnchor.addChild(occlusionPlane)
            print("ADDED VERTICAL PLANE")
        }
    }
}



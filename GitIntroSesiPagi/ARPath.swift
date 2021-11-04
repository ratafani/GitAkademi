//
//  RKPathEntity.swift
//  RKPathMaker+Example
//
//  Created by Grant Jarvis on 3/13/21.
//  Copyright © 2021 Grant Jarvis. All rights reserved.
//

import SceneKit
import RealityKit

public class RKPathEntity : Entity, HasAnchoring {
    
    weak var arView : ARView!
    
    public var pathPoints = [simd_float3]() {
        didSet {
            self.children.removeAll()
            recalcGeometry()
        }
    }
   
    private var pathMaterials : [Material]?
    
    private var pathWidth : Float = 0.005
    
    public init(
        arView: ARView,
        path: [simd_float3] = [],
        width: Float = 0.005,
        materials: [Material] = []
    ) {
        super.init()
        self.arView = arView
        self.pathPoints = path
        self.pathWidth = width
        self.pathMaterials = materials
        self.anchoring = AnchoringComponent(.world(transform: Transform.identity.matrix))
        self.arView.scene.addAnchor(self)
        
        //Remove synchronization to save memory.
        self.visit(using: {$0.synchronization = nil})
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }

    func recalcGeometry() {
        
        for currentIndex in 0..<pathPoints.count {
            //Using a smaller distance between points on a curve will lead to smoother curves.

            //Keep all y-values the same so that the ends don't protrude in the y-dimension (looks more like disjointed shapes than one continouous path).
            let newPosition : SIMD3<Float> = pathPoints[currentIndex]
            var lastPosition : SIMD3<Float>
            if currentIndex == 0 { //currentIndex - 1 does not exist for this index.
                lastPosition = newPosition
            } else {
                lastPosition = [pathPoints[currentIndex - 1].x,
                                             newPosition.y,
                                             pathPoints[currentIndex - 1].z]
            }

            let length = simd_length(newPosition - lastPosition)
            let pathSegment = makePathSegment(length: length,width: pathWidth)
            
            self.addChild(pathSegment)
            
            pathSegment.position = lastPosition

            //Rotate the rectangle to connect the dots.
            // --(lastPosition is already at one end of the rectangle, rotate to put newPosition at the other end).
            pathSegment.look(at: newPosition, from: lastPosition, relativeTo: nil)
//            textSegment.look(at: newPosition, from: lastPosition, relativeTo: nil)
//            textSegment.position.z÷ = 1
            //Account for updates in the plane anchor accuracy, but keep the whole path flat.
            self.children.forEach { pathEntity in
                pathEntity.position.y = newPosition.y
            }
            let textSegment = makeTextEntity(length: length)
            self.addChild(textSegment)
            textSegment.position = newPosition
            textSegment.position.y = newPosition.y+0.02
        }
    }
    
    func makePathSegment(length: Float, width: Float = 0.005) -> Entity {
        let pivotPoint = Entity()
        let rectangleMesh = MeshResource.generatePlane(width: width, depth: length + width, cornerRadius: width / 2)
        let generatedRectangle = ModelEntity(mesh: rectangleMesh,
                                             materials: pathMaterials ?? [UnlitMaterial.init(color: .blue)])
        pivotPoint.addChild(generatedRectangle)
        
        //This shape can be broken down into 3 parts: 1 rectangle of length length, and 2 ends that are half-circles of radius pathWidth / 2.
        //The center of the pivot point should be placed at the center of the half-circle at one end of the rectangle; We want each path segment to overlap on the half-circle tips so that the path has rounded joints.
        let zPosition = (-(length + width) / 2) + (width / 2)
        
        generatedRectangle.position = [0,0,zPosition]
        return pivotPoint
    }
    
    func makeTextEntity(length:Float)->Entity{
        let text = Entity()
        let lineHeight: CGFloat = 0.01
        let font = MeshResource.Font.systemFont(ofSize: lineHeight)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .ceiling
        formatter.maximumFractionDigits = 2
        
        let meter = formatter.string(from: NSNumber(value: length))! + "meter"
        
        let textMesh = MeshResource.generateText("\(meter)", extrusionDepth: Float(lineHeight * 0.1), font: font)
        let generatedText = ModelEntity(mesh: textMesh, materials: [UnlitMaterial.init(color: .green)])
        
        text.addChild(generatedText)
        
//        let zPosition = (-(length + 0.005) / 2) + (0.005 / 2)
//        generatedText.position = [0,0,zPosition]
        
        return text
    }
}



extension Entity {
    func visit(using block: (Entity) -> Void) {
        block(self)
        for child in children {
            child.visit(using: block)
        }
    }
}

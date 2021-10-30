/*
See LICENSE folder for this sample’s licensing information.

Code from Apple PlacingObjects demo: https://developer.apple.com/sample-code/wwdc/2017/PlacingObjects.zip

Abstract:
Utility functions and type extensions used throughout the projects.
*/

import Foundation
import ARKit

extension simd_float4x4 {
    var vector_position: SCNVector3 {
        return SCNVector3(columns.3.x, columns.3.y, columns.3.z)
    }
    var simd_position: SIMD3<Float> {
        return SIMD3<Float>(columns.3.x, columns.3.y, columns.3.z)
    }
}

extension SCNGeometry {
    class func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]

        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)

        return SCNGeometry(sources: [source], elements: [element])
    }
}


extension SCNVector3 {
    static func distanceFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> Float {
        let x0 = vector1.x
        let x1 = vector2.x
        let y0 = vector1.y
        let y1 = vector2.y
        let z0 = vector1.z
        let z1 = vector2.z

        return sqrtf(powf(x1-x0, 2) + powf(y1-y0, 2) + powf(z1-z0, 2))
    }
    
    
    static func getCenter(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SIMD3<Float>{
        let x = (vector1.x + vector2.x)/2
        let y = (vector1.y + vector2.y)/2
        let z = (vector1.z + vector2.z)/2
        
        return [x,y,z]
    }
    
    func toSIMD3()-> SIMD3<Float>{
        return [self.x,self.y,self.z]
    }
}

extension Float {
    func metersToInches() -> Float {
        return self * 39.3701
    }
    
    func pow2() -> Float{
        return self * self
    }
}


extension simd_float3x3{
    var cgPoints: CGPoint {
        return CGPoint(x: CGFloat(columns.2.x),y:CGFloat(columns.2.z))
    }
}

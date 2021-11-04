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

//
//  SlopeColor.swift
//  Lift Off
////

import Foundation
import SceneKit

// Maps slope values to a color vector

let SlopeColor: [SCNVector3] = [
    // Red, Green, Blue
    
    
    SCNVector3(x: 1, y: 0, z: 1),   // 0
    SCNVector3(x: 1, y: 0, z: 1),
    SCNVector3(x: 1, y: 0, z: 1),
    SCNVector3(x: 1, y: 0, z: 1),
    SCNVector3(x: 0.9, y: 0, z: 1),
    SCNVector3(x: 0.8, y: 0, z: 1),
    SCNVector3(x: 0.7, y: 0, z: 1),
    SCNVector3(x: 0.6, y: 0, z: 1),
    SCNVector3(x: 0.5, y: 0, z: 1),
    SCNVector3(x: 0.4, y: 0, z: 1),
    SCNVector3(x: 0.3, y: 0, z: 1),   // 10
    SCNVector3(x: 0.2, y: 0, z: 1),
    SCNVector3(x: 0.1, y: 0, z: 1),
    SCNVector3(x: 0.09, y: 0, z: 1),
    SCNVector3(x: 0.08, y: 0, z: 1),
    SCNVector3(x: 0.07, y: 0, z: 1),
    SCNVector3(x: 0.06, y: 0, z: 1),
    SCNVector3(x: 0.05, y: 0, z: 1),
    SCNVector3(x: 0.04, y: 0, z: 1),
    SCNVector3(x: 0.03, y: 0, z: 1),
    SCNVector3(x: 0.02, y: 0, z: 1),   // 20
    SCNVector3(x: 0.01, y: 0, z: 1),
    SCNVector3(x: 0, y: 0, z: 1),
    SCNVector3(x: 0, y: 0, z: 1),
    SCNVector3(x: 0, y: 0, z: 1),
    SCNVector3(x: 0, y: 0, z: 1),
    SCNVector3(x: 0, y: 0, z: 1),
    SCNVector3(x: 0, y: 0, z: 1),
    SCNVector3(x: 0, y: 0, z: 1),
    SCNVector3(x: 0, y: 0.0, z: 1),
    SCNVector3(x: 0, y: 0.1, z: 1),   // 30
    SCNVector3(x: 0, y: 0.2, z: 0.9),
    SCNVector3(x: 0, y: 0.3, z: 0.8),
    SCNVector3(x: 0, y: 0.4, z: 0.7),
    SCNVector3(x: 0, y: 0.5, z: 0.6),
    SCNVector3(x: 0, y: 0.6, z: 0.4),
    SCNVector3(x: 0, y: 0.7, z: 0.3),
    SCNVector3(x: 0, y: 0.8, z: 0.2),
    SCNVector3(x: 0, y: 0.9, z: 0.1),
    SCNVector3(x: 0, y: 1, z: 0.1),
    SCNVector3(x: 0, y: 1, z: 0.08), //40
    SCNVector3(x: 0, y: 1, z: 0.06),
    SCNVector3(x: 0, y: 1, z: 0.04),
    SCNVector3(x: 0, y: 1, z: 0.02),
    SCNVector3(x: 0, y: 1, z: 0),
    SCNVector3(x: 0, y: 1, z: 0),
    SCNVector3(x: 0, y: 1, z: 0),
    SCNVector3(x: 0.1, y: 1, z: 0),
    SCNVector3(x: 0.2, y: 0.9, z: 0),
    SCNVector3(x: 0.3, y: 0.8, z: 0),
    SCNVector3(x: 0.4, y: 0.7, z: 0), //50
    SCNVector3(x: 0.5, y: 0.6, z: 0),
    SCNVector3(x: 0.6, y: 0.5, z: 0),
    SCNVector3(x: 0.7, y: 0.4, z: 0),
    SCNVector3(x: 0.8, y: 0.3, z: 0),
    SCNVector3(x: 0.9, y: 0.2, z: 0),
    SCNVector3(x: 1, y: 0.1, z: 0),
    SCNVector3(x: 1, y: 0.08, z: 0),
    SCNVector3(x: 1, y: 0.06, z: 0),
    SCNVector3(x: 1, y: 0.04, z: 0),
    SCNVector3(x: 1, y: 0.02, z: 0), //60
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0), //70
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0), //80
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),//90
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0),
    SCNVector3(x: 1, y: 0, z: 0) //93

]

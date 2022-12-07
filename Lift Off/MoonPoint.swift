//
//  MoonPoint.swift
//

import Foundation
import SceneKit

struct MoonPoint {
    var latitude: Double
    var longitude: Double
    var height: Double
    var slope: Double
}

typealias MoonSurface = [[MoonPoint]]

extension MoonPoint {
    static let csvW = 100
    static let csvH = 100
    
    var maxDim: Int{
        return Swift.max(MoonPoint.csvW, MoonPoint.csvH)
    }
    
    
    static func buildArray() -> MoonSurface {
        let latitude = decodeCsvNumberFile(name: "latitude100x100")
        let longitude = decodeCsvNumberFile(name: "longitude100x100")
        let height = decodeCsvNumberFile(name: "height100x100")
        let slope = decodeCsvNumberFile(name: "slope100x100")
        // print(results)
        var points: [[MoonPoint]] = []
        for y in 0..<csvH {
            var row: [MoonPoint] = []
            for x in 0..<csvW {
                row.append(MoonPoint(latitude: latitude[y][x], longitude: longitude[y][x], height: height[y][x], slope: slope[y][x]))
            }
            points.append(row)
        }
        // print(points)
        // print(points[0][0])
        return points
    }

    static func decodeCsvNumberFile(name: String) -> [[Double]] {
        var result: [[Double]] = []
        if let url = Bundle.main.url(forResource: name, withExtension:  "csv") {
            do {
                let s = try String(contentsOf: url)
                let lines = s.split(whereSeparator: \.isNewline)
                for line in lines {
                    let columns = line.split(separator: ",")
                    var row: [Double] = []
                    for column in columns {
                        if let d = Double(column) {
                            row.append(d)
                        }
                    }
                    result.append(row)
                }
            } catch {
            }
        }
        return result
    }

}

extension MoonSurface {

    func heightAt(x: Float, z: Float) -> Float {
        let scale = Float(40.0)
        let xDivided = x / scale
        let zDivided = z / -scale
        let xZero = Int(xDivided)
        let xOne = Int(xDivided + 1)
        let zZero = Int(zDivided)
        let zOne = Int(zDivided + 1)
        
    
        let yZero = (self[zZero][xZero].height)
        let yOne = (self[zZero][xOne].height)
    
        let y = Float(yZero) + (xDivided - Float(xZero)) * (Float(yOne - yZero))
   
        let yZeroTop = (self[zOne][xZero].height)
        let yOneTop = (self[zOne][xOne].height)
                            
        let yTop = Float(yZeroTop) + (xDivided - Float(xZero)) * (Float(yOneTop - yZeroTop))
        
        let yMid = Float(y) + (zDivided - Float(zZero)) * (Float(yTop - y))

                         
                         
        return Float(yMid)
    }
    
    func point3dAt(x: Int, y: Int) -> SCNVector3 {
        let scale: Float = 40.0
        let point = SCNVector3(x: scale * Float(x), y: Float(self[y][x].height), z: -scale * Float(y))
        return point
    }

    func slopeColorAt(x: Int, y: Int) -> SCNVector3 {
        let slope = Int(self[y][x].slope)
        let color = AltSlopeColor[slope]
        return color
    }

    func normalAt(x: Int, y: Int) -> SCNVector3 {
        var sign: Float = 1
        var x2 = x + 1
        var y2 = y + 1
        if x >= MoonPoint.csvW - 1{
            x2 = x - 1
            sign *= -1
        }
        
        if y >= MoonPoint.csvH - 1 {
            y2 = y - 1
            sign *= -1
        }
        
        let p1 = point3dAt(x: x, y: y)
        let p2 = point3dAt(x: x2, y: y)
        let p3 = point3dAt(x: x, y: y2)
        
        // Vector A from p1 to p2
        // Vector B from p1 to p3
        let a = SCNVector3(x: p2.x - p1.x, y: p2.y - p1.y, z: p2.z - p1.z)
        let b = SCNVector3(x: p3.x - p1.x, y: p3.y - p1.y, z: p3.z - p1.z)
        
        // Cross product of AxB
        let nx = sign * (a.y * b.z - a.z * b.y)
        let ny = sign * (a.z * b.x - a.x * b.z)
        let nz = sign * (a.x * b.y - a.y * b.x)
        let normal = SCNVector3(x: nx, y: ny, z: nz)
        return normal
    }
}


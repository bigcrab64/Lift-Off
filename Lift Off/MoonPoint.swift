//
//  MoonPoint.swift
//

import Foundation

struct MoonPoint {
    var latitude: Double
    var longitude: Double
    var height: Double
    var slope: Double
}

extension MoonPoint {

    static func buildArray() -> [[MoonPoint]] {
        let latitude = decodeCsvNumberFile(name: "latitude")
        let longitude = decodeCsvNumberFile(name: "longitude")
        let height = decodeCsvNumberFile(name: "height")
        let slope = decodeCsvNumberFile(name: "slope")
        // print(results)
        var points: [[MoonPoint]] = []
        for y in 0...9 {
            var row: [MoonPoint] = []
            for x in 0...9 {
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

//
//  GameViewController.swift
//  GeometryFighter
//
//  Created by De La Torre, Julian - Student on 10/27/22.
//

import UIKit
import QuartzCore
import SceneKit

// NOTE: this provides one triangle with different vertices of red/green/blue.
//       Selector allows looking at texture mapping.

class GameViewController: UIViewController {

    var selectedSegment = 0

    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!

    func setupView() {
        scnView = self.view as? SCNView
        // 1
        scnView.showsStatistics = true
        // 2
        scnView.allowsCameraControl = true
        // 3
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = UIColor.gray
    }

    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
    }

    func setupCamera() {
        // 1
        cameraNode = SCNNode()
        // 2
        cameraNode.camera = SCNCamera()
        // 3
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        // 4
        scnScene.rootNode.addChildNode(cameraNode)
    }

    func setupGeometry() {
        // Vertex
        let vertices: [SCNVector3] = [SCNVector3(-1, 0, 0),
                                      SCNVector3(0, 0, 0),
                                      SCNVector3(1, 0, 0),
                                      SCNVector3(-1, 1, 0),
                                      SCNVector3(0, 1, 0),
                                      SCNVector3(1, 1, 0)]

        let vertexSource = SCNGeometrySource.init(data: vertices, semantic: .vertex)

        // Faces
        let indices: [Int32] = [4,4, 0,1,4,3, 1,2,5,4]

        let indexData = Data(bytes: indices, count: indices.count * MemoryLayout<Int32>.size)
        let indexElement = SCNGeometryElement(data: indexData,
                                              primitiveType: SCNGeometryPrimitiveType.polygon,
                                              primitiveCount: indices.count / 5,
                                              bytesPerIndex: MemoryLayout<Int32>.size)

        // Normals
        let normals: [SCNVector3] = [SCNVector3(0, 0, 1),
                                     SCNVector3(0, 0, 1),
                                     SCNVector3(0, 0, 1),
                                     SCNVector3(0, 0, 1),
                                     SCNVector3(0, 0, 1),
                                     SCNVector3(0, 0, 1)]

        let normalSource = SCNGeometrySource.init(data: normals, semantic: .normal)

        // Colors
        let colors: [SCNVector3] = [SCNVector3(1, 0, 0.3),//bottom vertices
                                    SCNVector3(0.5, 0, 0.5),
                                    SCNVector3(0, 0, 1),
                                    SCNVector3(1, 0, 0.3),//top vertices
                                    SCNVector3(0.5, 0, 0.5),
                                    SCNVector3(0, 0, 1)]

        let colorSource = SCNGeometrySource.init(data: colors, semantic: .color)

        // Textures

        let uvList:[simd_float2] = [simd_float2(x: 0, y: 0),
                                    simd_float2(x: 0.5, y: 0),
                                    simd_float2(x: 1, y: 0),
                                    simd_float2(x: 0, y: 1),
                                    simd_float2(x: 0.5, y: 1),
                                      simd_float2(x: 1, y: 1)]

        //fill UV list with texture coords

        let uvData = Data(bytes: uvList, count: uvList.count * MemoryLayout<simd_float2>.size)
        let uvSource = SCNGeometrySource(data: uvData,
                                         semantic: SCNGeometrySource.Semantic.texcoord,
                                         vectorCount: uvList.count,
                                         usesFloatComponents: true,
                                         componentsPerVector: 2,
                                         bytesPerComponent: MemoryLayout<Float>.size,
                                         dataOffset: 0,
                                         dataStride: MemoryLayout<simd_float2>.size)

        // Materials
        let imageMaterial = SCNMaterial()
        imageMaterial.diffuse.contents = UIImage(named: "waves")

        let whiteMaterial = SCNMaterial()
        whiteMaterial.diffuse.contents = UIColor.white

        // Geometry
        let shapeGeometry: SCNGeometry
        switch selectedSegment {
            case 1:
                shapeGeometry = SCNGeometry(sources: [vertexSource, normalSource, colorSource], elements: [indexElement])
                shapeGeometry.materials = [whiteMaterial]
            case 2:
                shapeGeometry = SCNGeometry(sources: [vertexSource, normalSource, uvSource], elements: [indexElement])
                shapeGeometry.materials = [imageMaterial]
            case 3:
                shapeGeometry = SCNGeometry(sources: [vertexSource, normalSource, uvSource, colorSource], elements: [indexElement])
                shapeGeometry.materials = [imageMaterial]
            default:
                shapeGeometry = SCNGeometry(sources: [vertexSource, normalSource], elements: [indexElement])
                shapeGeometry.materials = [whiteMaterial]
        }

        let shapeNode = SCNNode(geometry: shapeGeometry)
        shapeNode.position = SCNVector3(0, 0, 0)

        if let root = scnView.scene?.rootNode {
            // NOTE: first node used by camera from setupCamera().
            if root.childNodes.count < 2 {
                root.addChildNode(shapeNode)
            } else {
                root.replaceChildNode(root.childNodes[1], with: shapeNode)
            }
        }

    }

    
    
    @objc func segmentChanged(sender: UISegmentedControl) {
        selectedSegment = sender.selectedSegmentIndex
        setupGeometry()
    }

    func setupSegControl() {
        let viewW = self.view.frame.width
        let viewH = self.view.frame.height
        let segW = min(500, viewW - 20) // Keep to reasonable size, even on iPad
        let segCtrl = UISegmentedControl(items: ["No Color", "Color", "Texture", "Color+Texture"])
        segCtrl.frame = CGRect(x: 0.5 * (viewW - segW), y: viewH - 100, width: segW, height: 40)
        segCtrl.backgroundColor = .white
        segCtrl.selectedSegmentIndex = 0
        segCtrl.addTarget(self, action: #selector(segmentChanged(sender:)), for: .valueChanged)
        self.view.addSubview(segCtrl)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()

        setupSegControl()
        setupGeometry()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}

extension SCNGeometrySource {
    convenience init(data: [SCNVector3], semantic: SCNGeometrySource.Semantic) {
        let dataData = Data(bytes: data, count: data.count * MemoryLayout<SCNVector3>.size)
        self.init(data: dataData,
                  semantic: semantic,
                  vectorCount: data.count,
                  usesFloatComponents: true,
                  componentsPerVector: 3,
                  bytesPerComponent: MemoryLayout<Float>.size,
                  dataOffset: 0,
                  dataStride: MemoryLayout<SCNVector3>.size)
    }

}


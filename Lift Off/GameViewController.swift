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
    
    var surface: MoonSurface = []
    
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
        cameraNode.position = SCNVector3(x: 200, y: -1300, z: -200)
        cameraNode.camera?.zFar = 2000
        cameraNode.camera? .zNear = 0
        // 4
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    @objc func rotateCamera()
    {
        var angles = cameraNode.eulerAngles
        angles.y += 0.1
        cameraNode.eulerAngles = angles
    }
    
    func rotateAround()
    {
        DispatchQueue.global(qos: .userInitiated).async {
            for i in 0...1000{
                DispatchQueue.main.async {
                    self.rotateCamera()
                }
                usleep(100000)
            }
        }
    }

    func setupGeometry() {
        //Vertices
        
        var vertices: [SCNVector3] = []
        
        for i in 0...9 {
            for j in 0...9 {
                vertices.append(surface.point3dAt(x: j, y: i))
               // vertices.append(SCNVector3(x: 40 * Float(j), y: Float(surface[i][j].height), z: 40 * Float(i)))
            }
        }
        
        
        
      /*
        let vertices: [SCNVector3] = [SCNVector3(0, 0, 0),    //0
                                      SCNVector3(40, 0, 0),   //1
                                      SCNVector3(80, 0, 0),   //2
                                      
                                      SCNVector3(0, 0, -40),  //3
                                      SCNVector3(40, 0, -40), //4
                                      SCNVector3(80, 0, -40), //5
                                      
                                      SCNVector3(0, 0, -80),  //6
                                      SCNVector3(40, 0, -80), //7
                                      SCNVector3(80, 1, -80)] // 8
        */
        

        let vertexSource = SCNGeometrySource.init(data: vertices, semantic: .vertex)

        // Faces
        //let indices: [Int32] = [4,4,4,4, 0,1,4,3, 1,2,5,4, 3,4,7,6, 4,5,8,7  ]
        
        var indices:   [Int32] = []
        
        for _ in 0..<81 {
            indices.append(4)
        }
        for i in 0...8 {
        
            for j in 0...8 {
                indices.append(Int32((i * 10) + j))
                indices.append(Int32((i * 10) + j + 1))
                indices.append(Int32(((i + 1) * 10) + j + 1))
                indices.append(Int32(((i + 1) * 10) + j))
            }
        }
                
                
                
        let indexData = Data(bytes: indices, count: indices.count * MemoryLayout<Int32>.size)
        let indexElement = SCNGeometryElement(data: indexData,
                                              primitiveType: SCNGeometryPrimitiveType.polygon,
                                              primitiveCount: indices.count / 5,
                                              bytesPerIndex: MemoryLayout<Int32>.size)

        // Normals
   //     let normals: [SCNVector3] = [SCNVector3(0, 0, 1),
   //                                  SCNVector3(0, 0, 1),
  //                                   SCNVector3(0, 0, 1),
  //                                   SCNVector3(0, 0, 1),
  //                                   SCNVector3(0, 0, 1),
 //                                    SCNVector3(0, 0, 1)]
        var normals:[SCNVector3] = []
        
        for i in 0...9 {
            for j in 0...9{
                normals.append(surface.normalAt(x: j, y: i))
            }
        }
        

        let normalSource = SCNGeometrySource.init(data: normals, semantic: .normal)

        // Colors
        var colors: [SCNVector3] = []
        
        for i in 0...9 {
            for j in 0...9{
                colors.append(surface.slopeColorAt(x: j, y: i))
            }
        }
        let colorSource = SCNGeometrySource.init(data: colors, semantic: .color)

        // Textures

        let uvList:[simd_float2] = [simd_float2(x: 0, y: 0),
                                    simd_float2(x: 0.01, y: 0),
                                    simd_float2(x: 1, y: 0),
                                    simd_float2(x: 0, y: 1),
                                    simd_float2(x: 0.01, y: 1),
                                    simd_float2(x: 0.01, y: 0),
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
    func setupRotateButton()
    {
        let viewW = self.view.frame.width
        let viewH = self.view.frame.height
        var button = UIButton(type: .custom)
        button = UIButton(frame: CGRect(x: 0.5 * (viewW - 200), y: viewH - 200, width: 200, height: 40))
        button.setTitle("rotate", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(rotateCamera), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
        setupSegControl()
        setupRotateButton()
        surface = MoonPoint.buildArray()
        setupGeometry()
        //rotateAround()
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



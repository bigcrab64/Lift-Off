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
    var sceneControl: SceneControlVC?
    
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
        scnView.backgroundColor = UIColor.blue
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
        cameraNode.position = SCNVector3(x: 200, y: -1200, z: -200)
        
        cameraNode.camera?.zNear = 0
        cameraNode.camera?.zFar = 1000
        
        // 4
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    @objc func rotateCamera () {
        var  angles = cameraNode.eulerAngles
        angles.y += 0.1
        cameraNode.eulerAngles = angles
    }
    
    @objc func rotateAround() {
        DispatchQueue.global(qos: .userInitiated) .async {
            for _ in  0...1000 {
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
                vertices.append(SCNVector3(x: 40 * Float(j), y: (Float(surface[i][j].height)), z: -40 * Float(i)))
            }
        }
       
        let vertexSource = SCNGeometrySource.init(data: vertices, semantic: .vertex)

        // Faces
        var indices:   [Int32] = []
        
        for _ in 1...(9 * 9) {
            indices.append(4)
        }
    
        for i in 0...8 {
        
            for j in 0...8 {
                
                indices.append(Int32((i * 10) + j))
                indices.append(Int32((i * 10) + (j + 1)))
                indices.append(Int32(((i + 1) * 10) + (j + 1)))
                indices.append(Int32(((i + 1) * 10) + j))
            }
        }
                
                
        let indexData = Data(bytes: indices, count: indices.count * MemoryLayout<Int32>.size)
        let indexElement = SCNGeometryElement(data: indexData,
                                              primitiveType: SCNGeometryPrimitiveType.polygon,
                                              primitiveCount: indices.count / 5,
                                              bytesPerIndex: MemoryLayout<Int32>.size)

        // Normals
        var normals: [SCNVector3] = []
       
        
        for i in 0...9 {
            for j in 0...9 {
                normals.append(surface.normalAt(x: j, y: i))
            }
        }

        let normalSource = SCNGeometrySource.init(data: normals, semantic: .normal)

        // Colors
        var colors: [SCNVector3] = []

        for i in 0...9 {
            for j in 0...9 {
                colors.append(surface.slopeColorAt(x: j, y: i))
            }
        }
        
        let colorSource = SCNGeometrySource.init(data: colors, semantic: .color)
        // Textures

      /*  let uvList:[simd_float2] = [simd_float2(x: 0, y: 0),
                                    simd_float2(x: 0.5, y: 0),
                                    simd_float2(x: 1, y: 0),
                                    simd_float2(x: 0, y: 1),
                                    simd_float2(x: 0.5, y: 1),
                                      simd_float2(x: 1, y: 1)]
        */
     
        
        var uvList: [simd_float2] = []
    
       for point in vertices {
           uvList.append(simd_float2(point.x, point.z))
        }
        
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
    
    func setupRotateButton () {
        let viewW = self.view.frame.width
        let viewH = self.view.frame.height
        let button = UIButton(frame: CGRect(x: 0.75 * (viewW - 200), y: viewH - 750, width: 100, height: 40))
        button.setTitle("Rotate", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(rotateAround), for: .touchUpInside)
        self.view.addSubview(button)
    }
    @objc func showControls() {
        let storyboard = UIStoryboard(name: "SceneControlVC", bundle: nil)
        if let controller = storyboard.instantiateInitialViewController() as? SceneControlVC {
            let bounds = self.view.bounds
            let frame = CGRect(x: 0.5 * (bounds.width - 300), y: bounds.height - 400, width: 300, height: 300)
            controller.configure(camPosition: cameraNode.position, delegate: self)
            controller.view.frame = frame
            self.view.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
    }
    func setupControlButton() {
        let viewW = self.view.frame.width
        // let viewH = self.view.frame.height
        let button = UIButton(frame: CGRect(x: viewW - 60, y: 60, width: 44, height: 44))
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(showControls), for: .touchUpInside)
        self.view.addSubview(button)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
        setupRotateButton()
        setupSegControl()
        setupControlButton()
        surface = MoonPoint.buildArray()
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

extension GameViewController: SceneControlProtocol {
    func updateCamPos(_ position: SCNVector3) {
        cameraNode.position = position
    }
    
    
}

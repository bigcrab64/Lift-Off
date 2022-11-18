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
    var lightNode: SCNNode!
    
    func setupView() {
        scnView = self.view as? SCNView
        // 1
        scnView.showsStatistics = true
        // 2
        scnView.allowsCameraControl = false
        // 3
        scnView.autoenablesDefaultLighting = false
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
        cameraNode.position = SCNVector3(x: 200, y: -1200, z: 400)
        
        cameraNode.camera?.zNear = 0
        cameraNode.camera?.zFar = 1000
        
        // 4
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func setupLights () {
        
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor(white: 0.3, alpha: 1)
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        scnScene.rootNode.addChildNode(ambientLightNode)
        
        let omniLight = SCNLight()
        omniLight.type = .omni
        omniLight.color = UIColor.white
        omniLight.intensity = 1000
        lightNode = SCNNode()
        lightNode.light = omniLight
        lightNode.position = SCNVector3(x: -400, y: -1200, z: 0)
        scnScene.rootNode.addChildNode(lightNode)
    }
    
    
    @objc func rotateCamera () {
        var  angles = cameraNode.eulerAngles
        angles.y += 0.1
        cameraNode.eulerAngles = angles
    }
    
    @objc func rotateCameraOtherway () {
        var  angles = cameraNode.eulerAngles
        angles.y -= 0.1
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
        
        for i in 0..<MoonPoint.csvH {
            for j in 0..<MoonPoint.csvW {
                vertices.append(SCNVector3(x: 40 * Float(j), y: (Float(surface[i][j].height)), z: -40 * Float(i)))
            }
        }
       
        let vertexSource = SCNGeometrySource.init(data: vertices, semantic: .vertex)

        // Faces
        var indices:   [Int32] = []
        let csvHMone = MoonPoint.csvH - 1
        let csvWMone = MoonPoint.csvW - 1
        
        for _ in 1...( csvHMone * csvWMone) {
            indices.append(4)
        }
    
        for i in 0..<csvHMone {
        
            for j in 0..<csvWMone {
                
                indices.append(Int32((i * MoonPoint.csvW) + j))
                indices.append(Int32((i * MoonPoint.csvW) + (j + 1)))
                indices.append(Int32(((i + 1) * MoonPoint.csvW) + (j + 1)))
                indices.append(Int32(((i + 1) * MoonPoint.csvW) + j))
            }
        }
                
                
        let indexData = Data(bytes: indices, count: indices.count * MemoryLayout<Int32>.size)
        let indexElement = SCNGeometryElement(data: indexData,
                                              primitiveType: SCNGeometryPrimitiveType.polygon,
                                              primitiveCount: indices.count / 5,
                                              bytesPerIndex: MemoryLayout<Int32>.size)

        // Normals
        var normals: [SCNVector3] = []
       
        
        for i in 0...csvHMone {
            for j in 0...csvWMone {
                normals.append(surface.normalAt(x: j, y: i))
            }
        }

        let normalSource = SCNGeometrySource.init(data: normals, semantic: .normal)

        // Colors
        var colors: [SCNVector3] = []

        for i in 0...csvHMone {
            for j in 0...csvWMone {
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
        shapeNode.name = "surface"

        if let root = scnView.scene?.rootNode {
            // NOTE: first node used by camera from setupCamera().
         //   if root.childNodes.count < 2 {
           //     root.addChildNode(shapeNode)
            //} else {
                //root.replaceChildNode(root.childNodes[1], with: shapeNode)
         //   }
            if let oldSurface = root.childNode(withName: "surface", recursively: false) {
                root.replaceChildNode(oldSurface, with: shapeNode)
            } else {
                root.addChildNode(shapeNode)
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
        let button = UIButton(frame: CGRect(x: 70, y: 100, width: 50, height: 40))
        button.setTitle("<", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(rotateCamera), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    func setupRotateButtonAgain () {
        let viewW = self.view.frame.width
        let viewH = self.view.frame.height
        let button = UIButton(frame: CGRect(x: viewW - 70, y: 100, width: 50, height: 40))
        button.setTitle(">", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(rotateCameraOtherway), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func resetPosition () {
        cameraNode.position = SCNVector3(x: 903.291, y: -1068.1818, z: -2989.8994)
        
        lightNode.position = SCNVector3(x: 96.20252, y: -1041.6666, z: -244.44452)
        cameraNode.camera?.zNear = 1
        cameraNode.camera?.zFar = 15000
    }
    
    func setupResetButton () {
        let viewW = self.view.frame.width
        let viewH = self.view.frame.height
        let button = UIButton(frame: CGRect(x: 340, y: 40, width: 50, height: 40))
        button.setTitle("reset", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(resetPosition), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func moveForward () {
        let dX = -(10 * sin(cameraNode.eulerAngles.y))
        let dZ = -(10 * cos(cameraNode.eulerAngles.y))
        let newY = surface.heightAt(x: cameraNode.position.x, z: cameraNode.position.z)
        
        var newCameraPosition = SCNVector3((cameraNode.position.x + dX), newY + 5, (cameraNode.position.z + dZ))
        cameraNode.position = newCameraPosition
    }
    
    func setupForwardButton() {
        let viewW = self.view.frame.width
        let viewH = self.view.frame.height
        let button = UIButton(frame: CGRect(x: 100, y: viewH - 200, width: 80, height: 40))
        button.setTitle("forward", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(moveForward), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func moveBackwards () {
        let dX = (10 * sin(cameraNode.eulerAngles.y))
        let dZ = (10 * cos(cameraNode.eulerAngles.y))
        
        var newCameraPosition = SCNVector3((cameraNode.position.x + dX), cameraNode.position.y, (cameraNode.position.z + dZ))
        cameraNode.position = newCameraPosition
    }
    
    func setupBackwardsButton() {
        let viewW = self.view.frame.width
        let viewH = self.view.frame.height
        let button = UIButton(frame: CGRect(x: 100, y: viewH - 140, width: 90, height: 40))
        button.setTitle("backwards", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(moveBackwards), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    
    
    
    @objc func showTable() {
        if sceneControl == nil  {

            let storyboard = UIStoryboard(name: "SceneControlVC", bundle: nil)
            if let controller = storyboard.instantiateInitialViewController() as? SceneControlVC {
                let bounds = self.view.bounds
                let frame = CGRect(x: 0.5 * (bounds.width - 300), y: bounds.height - 400, width: 300, height: 300)
                
                let useNear = cameraNode.camera?.zNear ?? 0
                let useFar = cameraNode.camera?.zFar ?? 2000
                
                controller.configureScene(camPosition: cameraNode.position, near: Float(useNear), far: Float(useFar), lightPosition: lightNode.position, delegate: self)
                
                controller.view.frame = frame
                self.view.addSubview(controller.view)
                self.addChild(controller)
                controller.didMove(toParent: self)
                sceneControl = controller
            }
        }else {
            sceneControl?.willMove(toParent: nil)
            sceneControl?.view.removeFromSuperview()
            sceneControl?.removeFromParent()
            sceneControl = nil

            
            
        }
    }
    
    func setupControlButton() {
        let viewW = self.view.frame.width
        let button = UIButton(frame: CGRect(x: 320, y: 110, width: 100, height: 40))
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(showTable), for: .touchUpInside)
        self.view.addSubview(button)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
        setupLights()
        resetPosition()
        setupRotateButton()
        setupRotateButtonAgain()
        setupForwardButton()
        setupBackwardsButton()
        setupResetButton()
        setupControlButton()
        setupSegControl()
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
    func updateLightPos(_ pos: SCNVector3) {
        lightNode.position = pos
    }
    
    func updateNear(_ near: Float) {
        cameraNode.camera?.zNear = Double(near)
    }
    
    func updateFar(_ far: Float) {
        cameraNode.camera?.zFar = Double(far)
    }
    
    func updateCamPos(_ pos: SCNVector3) {
        cameraNode.position = pos
    }
}

//
//  SceneControlViewController.swift
//  Lift Off
//
//  Created by De La Torre, Julian - Student on 11/7/22.
//

import UIKit
import SceneKit

protocol SceneControlProtocol: AnyObject {
    func updateCamPos(_ pos: SCNVector3)
    func updateNear(_ near: Float)
    func updateFar(_ far: Float)

}


class SceneControlVC: UITableViewController {

    var camPosition = SCNVector3()
    var near: Float = 0
    var far: Float = 0
    
    weak var delegate : SceneControlProtocol?
    
    func configureScene(camPosition: SCNVector3, near: Float, far: Float, delegate: SceneControlProtocol) {
        
        self.camPosition = camPosition
        self.near = near
        self.far = far
        self.delegate = delegate
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let cid = "SliderCell"
        tableView.register(UINib(nibName: cid, bundle: nil), forCellReuseIdentifier: cid)
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (2)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (3)
        case 1:
            return (2)
        default:
            return (0)
        }
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Camera Position"
        case 1:
            return "Near and Far"
        default:
            return ":("
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            switch indexPath.row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SliderCell", for: indexPath) as? SliderCell {
                    cell.configure(title: "X", value: camPosition.x, min: -200 , max: 400, indexPath: indexPath, delegate: self)
                    return cell
                }
            case 1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SliderCell", for: indexPath) as? SliderCell {
                    cell.configure(title: "Y", value: camPosition.y, min: -1400 , max: -1200, indexPath: indexPath, delegate: self)
                    return cell
                }
            case 2:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SliderCell", for: indexPath) as? SliderCell {
                    cell.configure(title: "Z", value: camPosition.z, min: -400 , max: 600,indexPath: indexPath, delegate: self)
                    return cell
                    
                }
            default:
                break
            }
        case 1:
            
            switch indexPath.row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SliderCell", for: indexPath) as? SliderCell {
                    cell.configure(title: "Near", value: near, min: 0 , max: 2000, indexPath: indexPath, delegate: self)
                    return cell
                }
            case 1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SliderCell", for: indexPath) as? SliderCell {
                    cell.configure(title: "Far", value: far, min: 0 , max: 2000, indexPath: indexPath, delegate: self)
                    return cell
                }
            default:
                break
            }
        default:
            break
        }
        return UITableViewCell()
    }
}


extension SceneControlVC: SliderCellProtocol {
    func updateValue(_ value: Float, at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row{
            case 0:
                camPosition.x = value
            case 1:
                camPosition.y = value
            case 2:
                camPosition.z = value
            default:
                break
            }
        case 1:
            switch indexPath.row{
            case 0:
                near = value
                delegate?.updateNear(near)
            case 1:
                far = value
                delegate?.updateFar(far)
            default:
                break
            }
            delegate?.updateCamPos(camPosition)
        default:
            break
        }
            
    }
    
    
}

//
//  sceneCNT-VC.swift
//  Lift Off
//
//  Created by Williams, Alexander - Student on 11/7/22.
//

import UIKit
import SceneKit

protocol sceneCNTProtocol: AnyObject
{
    func updateCamPos(_ position: SCNVector3)
    func updateNear(_ near: Float)
    func updateFar(_ far: Float)
}


class sceneCNT_VC: UITableViewController {

    var camPosition = SCNVector3()
    var near: Float = 0
    var far: Float = 0
    
    weak var delegate : sceneCNTProtocol?
    func configure(camPosition: SCNVector3, near: Float, far: Float, delegate: sceneCNTProtocol)
    {
        self.camPosition = camPosition
        self.delegate = delegate
        self.near = near
        self.far = far
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let cid = "sliderCell"
        tableView.register(UINib(nibName: cid, bundle: nil), forCellReuseIdentifier: cid)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0: return 3
        case 1: return 2
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0: return "Cam Pos"
        case 1: return "Near/Far"
        default: return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundView = UIView()
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:    if let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as? sliderCell{
                cell.configure(title: "X", value: camPosition.x, min: -400, max: 400, indexPath: indexPath, delegate: self)
                return cell
            }
            case 1:    if let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as? sliderCell{
                cell.configure(title: "Y", value: camPosition.y, min: -1500, max: 1500, indexPath: indexPath, delegate: self)
                return cell
            }
            case 2:    if let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as? sliderCell{
                cell.configure(title: "Z", value: camPosition.z, min: -400, max: 400, indexPath: indexPath, delegate: self)
                return cell
            }
            default: break
            }
            
            
        case 1:
            switch indexPath.row{
        case 0:    if let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as? sliderCell{
            cell.configure(title: "near", value: camPosition.x, min: 0, max: 2000, indexPath: indexPath, delegate: self)
            return cell
        }
            case 1:    if let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as? sliderCell{
                cell.configure(title: "far", value: camPosition.y, min: 0, max: 2000, indexPath: indexPath, delegate: self)
                return cell
            }
            default: break
        }
        default: break
            
        }
    
        // Configure the cell...

        return UITableViewCell()
    }
    


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension sceneCNT_VC: SliderCelProtocol{
    func updateValue(_ value: Float, at indexPath: IndexPath) {
        print(value)
        switch indexPath.section{
        case 0:
            switch indexPath.row{
        case 0:
            camPosition.x = value
        case 1:
            camPosition.y = value
        case 2:
            camPosition.z = value
        default: break
        }
        case 1:
            switch indexPath.row{
            case 0:
                near = value
                delegate?.updateNear(near)
            case 1:
                far = value
                delegate?.updateFar(far)
            default: break
            }
        default: break
        }
       
        delegate?.updateCamPos(camPosition)
    }
}


//
//  sceneCNT-VC.swift
//  Lift Off
//
//  Created by Williams, Alexander - Student on 11/7/22.
//

import UIKit
import SceneKit

protocol SliderCelProtocol: AnyObject
{
    func updateCamPos(_ position: SCNVector3)
}


class sceneCNT_VC: UITableViewController {

    weak var delegate : SliderCelProtocol?
    func configure(camPosition: SCNVector3, delegate: SceneControlProtocal)
    {
        
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as? sliderCell{
            cell.configure(title: "X", value: 0, min: -400, max: 400, indexPath: indexPath, delegate: self)
            return cell
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
        camPosition.x = value
        delegate?.updateCamPos(camPosition)
    }
    
    
}

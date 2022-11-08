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
}


class SceneControlVC: UITableViewController {

    var camPosition = SCNVector3()
    
    weak var delegate : SceneControlProtocol?
    
    func configureScene(camPosition: SCNVector3, delegate: SceneControlProtocol) {
        self.camPosition = camPosition
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
        return (1)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (1)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SliderCell", for: indexPath) as? SliderCell {
            cell.configure(title: "X", value: 0, min: -400 , max: 400, indexPath: indexPath, delegate: self)
            return cell
        }

        return UITableViewCell()
    }
}

extension SceneControlVC: SliderCellProtocol {
    func updateValue(_ value: Float, at indexPath: IndexPath) {
        camPosition.x = value
        delegate?.updateCamPos(camPosition)
    }
    
    
}

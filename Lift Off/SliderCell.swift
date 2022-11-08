//
//  SliderCell.swift
//  Lift Off
//
//  Created by De La Torre, Julian - Student on 11/7/22.
//

import UIKit

protocol SliderCellProtocol: AnyObject {
    func updateValue(_ value: Float, at indexPath: IndexPath)
}

class SliderCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    weak var delegate : SliderCellProtocol?
    var indexPath = IndexPath()
    
    
    
    
    @objc func updateValue() {
        let value = slider.value
        valueLabel.text = String(value)
        delegate?.updateValue(value, at: indexPath)
    }
    
    
    func configure(title: String, value: Float, min: Float, max: Float, indexPath: IndexPath, delegate: SliderCellProtocol) {
        titleLabel.text = title
        valueLabel.text = String(value)
        slider.minimumValue = min
        slider.maximumValue = max
        slider.value = value
        self.indexPath = indexPath
        self.delegate = delegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        slider.addTarget(self, action: #selector(updateValue), for: .valueChanged)
    }

    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }

}

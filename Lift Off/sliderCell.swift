

import UIKit

protocol SliderCelProtocol: AnyObject
{
    func updateValue(_ value: Float, at indexPath: IndexPath)
}

class sliderCell: UITableViewCell {

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var valueLable: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    weak var delegate : SliderCelProtocol?
    var indexPath = IndexPath()
    
    @objc func updateValue()
    {
        let value = slider.value
        valueLable.text = "\(value)"
        delegate?.updateValue(value, at: indexPath)
        
    }
    
    
    func configure(title: String, value: Float, min: Float, max: Float, indexPath: IndexPath, delegate: SliderCelProtocol)
    {
        TitleLabel.text = title
        valueLable.text = "\(value)"
        slider.minimumValue = min
        slider.maximumValue = max
        slider.value = value
        self.indexPath = indexPath
        self.delegate = delegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        slider.addTarget(self, action: #selector(updateValue), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  CustomTableViewCell2.swift
//  GitIntroSesiPagi
//
//  Created by Local Administrator on 14/07/21.
//

import UIKit

class CustomTableViewCell2: UITableViewCell {

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var titleCell: UILabel!
    
    var zoomBackground:ZoomBackground!{
        didSet{
            updateUI()
        }
    }
    
    func updateUI(){
        titleCell.text = zoomBackground.title
        imageCell.image = UIImage(named: zoomBackground.image)
        imageCell.layer.cornerRadius = 5
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

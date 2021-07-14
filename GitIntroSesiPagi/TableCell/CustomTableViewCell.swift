//
//  CustomTableViewCell.swift
//  GitIntroSesiPagi
//
//  Created by Local Administrator on 14/07/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var descCell: UILabel!
    
    var zoomBackground:ZoomBackground!
    var extending : (()->Void?)!
    
    
    func updateUI(extending: @escaping ()->Void){
        titleCell.text = zoomBackground.title
        descCell.text = zoomBackground.detail
        cellImage.image = UIImage(named: zoomBackground.image)
        cellImage?.layer.cornerRadius = 5
        self.extending = extending
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func extendingCell(_ sender: Any) {
        extending()
    }
    
}

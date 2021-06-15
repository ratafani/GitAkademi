//
//  CustomCollectionViewCell.swift
//  GitIntroSesiPagi
//
//  Created by Muhammad Tafani Rabbani on 15/06/21.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func loadData(item: String){
        
        // hide item
        cellLabel.text = item
        
    }
}

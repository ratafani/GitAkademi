//
//  DetailViewController.swift
//  GitIntroSesiPagi
//
//  Created by Muhammad Tafani Rabbani on 21/06/22.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = image {
            imageView.image = image
        }
        // Do any additional setup after loading the view.
    }
    

}

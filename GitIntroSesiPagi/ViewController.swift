//
//  ViewController.swift
//  GitIntroSesiPagi
//
//  Created by Muhammad Tafani Rabbani on 11/06/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet weak var myView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded")
        
        myLabel.textColor = .white
        
        // change the label text
        myLabel.text = "Hello World."
        
        view.backgroundColor = .cyan
        
        myView.layer.cornerRadius = 10
    }

}


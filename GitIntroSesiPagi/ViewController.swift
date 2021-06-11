//
//  ViewController.swift
//  GitIntroSesiPagi
//
//  Created by Muhammad Tafani Rabbani on 11/06/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    
    var gender: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded")
        
        gender = "L"
        
        myLabel.textColor = .white
        
        // change the label text
        myLabel.text = "Hello World."
        
        myLabel.text = gender
        
        view.backgroundColor = .cyan
    }

}


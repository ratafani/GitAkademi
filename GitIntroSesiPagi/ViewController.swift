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
    var gender: String = ""
    
    var umurWorld  : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded")
        umurWorld = Int.random(in: 1...100)
        
        gender = "L"
        
        myLabel.textColor = .white
        
        // change the label text
        myLabel.text = "Hello World. \(umurWorld ?? 0)"
        
        myLabel.text = gender
        
        view.backgroundColor = .cyan
        
        myView.layer.cornerRadius = 10
    }

}


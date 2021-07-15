//
//  ViewController.swift
//  AnimationChallange1
//
//  Created by Muhammad Tafani Rabbani on 14/05/19.
//  Copyright © 2019 Muhammad Tafani Rabbani. All rights reserved.
//  Welcome

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var efSelection: UISegmentedControl!
    @IBOutlet weak var mCircle: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //view circle, untuk membulatkan view
        mCircle.layer.cornerRadius = mCircle.frame.size.width/2
        mCircle.clipsToBounds = true
        //enable tap, untuk memberi fungsi tap ke view
        // "#selector(clickView()) untuk memberi fungsi "clickView()" ke view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickView(_:)))
        tapGesture.delegate = self as? UIGestureRecognizerDelegate
        mCircle.addGestureRecognizer(tapGesture)
    }
   
    @objc func clickView(_ sender: UIView) {
        let sel = efSelection.selectedSegmentIndex
        // chosing animation
        if sel == 0{
            fadeOut()
        }else if sel == 1 {
            springMovement()
        }
    }
    
    // ini fungsi untuk animasi Bounce
    func springMovement(){
       // semakin besar "usingSpringWithDaping", semakin kecil efek pantulan
        // 0.1 == pantulan besar, 1 == tidak ada pantulan
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveLinear, animations: {
            //merubah posisi secara random
            self.changePos()
            //merubah warna secara random
            self.changeColor()
        }) { (isFinish) in
            
        }
    }
    // ini fungsi untuk merubah posisi secara random
    func changePos(){
        let randomX = Int.random(in: 1...300)
        let randomY = Int.random(in: 1...800)
        mCircle.center = CGPoint(x: randomX, y: randomY)
    }
    //ini fungsi untuk merubah warna secara random
    func changeColor(){
        let red = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        let yellow = Double.random(in: 0...1)
        mCircle.backgroundColor = UIColor.init(red: CGFloat(red), green: CGFloat(yellow), blue: CGFloat(blue), alpha: 1)
    }
    //ini fungsi untuk animasi menghilangkan view dengan efek fadeOut
    func fadeOut(){
        UIView.animate(withDuration: 0.5, animations: {
            // view di perbesar ukurannya menjadi 2 kalinya, agar memberi efek mengembang
            self.mCircle.transform = CGAffineTransform(scaleX: 2, y: 2)
            // view di di pudarkan
            self.mCircle.alpha = 0
            //fade out = semakin besar semakin pudar
        }) { (isFinished) in
            self.changePos()
            
            self.fadeIn()
        }
    }
    //ini fungsi untuk animasi memunculkan view dengan efek fadeIn
    func fadeIn(){
        UIView.animate(withDuration: 0.5) {
            // sebelumnya view di perbesar, sekarang di kembalikan ke ukuran semula
            self.mCircle.transform = CGAffineTransform(scaleX: 1, y: 1)
            // diberi warna baru secara random
            self.changeColor()
            // efek pudar di hilangkan kembali
            self.mCircle.alpha = 1
        }
    }
    
}


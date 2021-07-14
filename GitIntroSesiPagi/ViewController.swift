//
//  ViewController.swift
//  CoreData101
//
//  Created by Muhammad Tafani Rabbani on 10/08/20.
//  Copyright © 2020 Muhammad Tafani Rabbani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var name1: UITextField!
    
    
    @IBOutlet weak var name2: UITextField!
    
    
    @IBOutlet weak var saveBtn: UIButton!
    
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    
    var manager: CDManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CDManager()
        // Do any additional setup after loading the view.
        
        let img = UIImage(data: manager!.dataType.photo)
        
        imageView.image = img
        
        //ganti foto
        let ontap = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        imageView.addGestureRecognizer(ontap)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleToFill
        
        name1.text = manager!.dataType.name1
        name2.text = manager!.dataType.name2
    }
    
    
    @objc func tappedView(){
        print("image tapped")
        imagePicker.photoGalleryAsscessRequest()
    }
    
    @IBAction func saveName(_ sender: Any) {
        manager!.dataType.name1 = name1.text ?? ""
        manager!.dataType.name2 = name2.text ?? ""
        manager!.updateData(onSuccess: {
            print("Sucess")
        }) {
            print("error")
        }
    }
    
}

extension ViewController:ImagePickerDelegate{
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        
        manager!.dataType.photo = image.jpegData(compressionQuality: 1.0) ?? Data()
        manager!.updateData(onSuccess: {
            self.imageView.image = image
            self.imagePicker.dismiss()
        }) {
            
        }
    }
    
    func cancelButtonDidClick(on imageView: ImagePicker) { imagePicker.dismiss() }
    
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
}

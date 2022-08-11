//
//  DetailViewController.swift
//  GitIntroSesiPagi
//
//  Created by Muhammad Tafani Rabbani on 21/06/22.
//

import UIKit


class Service{
    var detailViewController:DetailViewController?
}

class DetailViewController: UIViewController {
    
    
    var owner: ViewController!
    var imageView: UIImageView!
    var image : UIImage?
    
    var animTimer : Timer!
    
    let service = Service()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.black
        
        // create an image view that fills the screen
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        
        view.addSubview(imageView)
        
        // make the image view fill the screen
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        // schedule an animation that does something vaguely interesting
        animTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            // do something exciting with our image
            self.imageView.transform = CGAffineTransform.identity
            
            UIView.animate(withDuration: 3) {
                self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        imageView.alpha = 0
        
        UIView.animate(withDuration: 3) { [unowned self] in
            self.imageView.alpha = 1
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = image {
            imageView.image = image
        }
        // Do any additional setup after loading the view.
        
        service.detailViewController = self
    }
    
    
    
    
}

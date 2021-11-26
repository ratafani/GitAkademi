//
//  ViewController.swift
//  CustomTableAfternoon
//
//  Created by Muhammad Tafani Rabbani on 26/04/21.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    @IBOutlet weak var zoomTable: UITableView!
    
    var arrZoom: [ZoomBackground] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupTable()
        addData()
        
        zoomTable.dataSource = self
        zoomTable.delegate = self
        //kasih tau data ke table
    }
    
    func setupTable(){
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        zoomTable.register(nib, forCellReuseIdentifier: "custom1")
        let nib2 = UINib(nibName: "CustomTableViewCell2", bundle: nil)
        zoomTable.register(nib2, forCellReuseIdentifier: "custom2")
    }
    
    func addData(){
        let a = ZoomBackground(title: "Jempol", detail: "Dipake saat setuju dengan teman mu", image: "patung_jempol")
        arrZoom.append(a)
        
        let b = ZoomBackground(title: "Potong Rambut", detail: "Dipake saat rambut mu butuh di potong", image: "top_collection")
        arrZoom.append(b)
        
        let c = ZoomBackground(title: "Rumah Mewah", detail: "Dipake saat ingin terlihat mewah mewahan", image: "rumah")
        arrZoom.append(c)
        
    }
    
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrZoom.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrZoom[indexPath.row].highlight{
            let cell = zoomTable.dequeueReusableCell(withIdentifier: "custom2") as! CustomTableViewCell2
            
            cell.zoomBackground = arrZoom[indexPath.row]
            
            
            return cell
        }else{
            let cell = zoomTable.dequeueReusableCell(withIdentifier: "custom1") as! CustomTableViewCell
            
            cell.zoomBackground = arrZoom[indexPath.row]
            cell.updateUI(){
                self.arrZoom[indexPath.row].highlight.toggle()
                UIView.transition(with: self.zoomTable, duration: 0.5, options: .transitionCrossDissolve) {
                    self.zoomTable.reloadData()
                }
            }
            
            return cell
        }
    }
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrZoom[indexPath.row].highlight{
            return zoomTable.frame.height / 4
        } else{
            return zoomTable.frame.height / 8
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if arrZoom[indexPath.row].highlight{
            arrZoom[indexPath.row].highlight.toggle()

            UIView.transition(with: zoomTable, duration: 0.5, options: .transitionCurlUp) {
                self.zoomTable.reloadData()
            }
            
            let window = self.view.window
            let nav = self.navigationController
            
            let swiftUIView = DetailView()
                .environmentObject(AppData(window: window,navigation: nav))
            
            let hostingController = UIHostingController(rootView: swiftUIView)
            
            self.navigationController?.show(hostingController, sender: nil)

            
            zoomTable.deselectRow(at: indexPath, animated: true)
        }else{
            zoomTable.deselectRow(at: indexPath, animated: true)
        }
    }
}

struct ZoomBackground {
    var title:String!
    var detail:String!
    var image:String!
    var highlight:Bool = false
}

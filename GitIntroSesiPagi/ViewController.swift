//
//  ViewController.swift
//  GitIntroSesiPagi
//
//  Created by Muhammad Tafani Rabbani on 11/06/21.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    var items = [String]()
    private var cancelable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cloudkit Exercise"
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.delegate = self
        myTableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        CloudkitManager.shared.fetchItem(recordType: "MyItem")
        
        CloudkitManager.shared.$myItems
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                self?.items = items
                self?.myTableView.reloadData()
            }
            .store(in: &cancelable)
    }
    
    @objc func didTapAdd(){
        let alert = UIAlertController(title: "Adding item", message: nil, preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = "name of item ..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler : { _ in
            if let field = alert.textFields?.first,let text = field.text, !text.isEmpty{
                CloudkitManager.shared.saveNameItem(name: text)
            }
        }))
        
        
        present(alert, animated: true)
    }
    

}



extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
}

extension ViewController : UITableViewDelegate{
    
}

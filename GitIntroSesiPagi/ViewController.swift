//
//  ViewController.swift
//  GitIntroSesiPagi
//
//  Created by Muhammad Tafani Rabbani on 11/06/21.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cloudkit Exercise"
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.delegate = self
        myTableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        CloudkitManager.shared.fetchItem(recordType: "MyItem", onSuccess: {
            [weak self] items in
            let newItems = items.map{$0 as! String}
            DispatchQueue.main.async {
                self?.items = newItems
                self?.myTableView.reloadData()
            }
            
        })
    }
    
    @objc func didTapAdd(){
        let alert = UIAlertController(title: "Adding item", message: nil, preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = "name of item ..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler : { _ in
            if let field = alert.textFields?.first,let text = field.text, !text.isEmpty{
                CloudkitManager.shared.saveNameItem(name: text){
                    CloudkitManager.shared.fetchItem(recordType: "MyItem", onSuccess: {
                        [weak self] items in
                        let newItems = items.map{$0 as! String}
                        DispatchQueue.main.async {
                            self?.items = newItems
                            self?.myTableView.reloadData()
                        }
                    })
                }
            }
        }))
        
        
        present(alert, animated: true)
    }
    

}


import CloudKit



class CloudkitManager{
    
    enum DBType {
        case dbPublic
        case dbPrivate
        case dbShared
    }
    
    private let dbPublic = CKContainer(identifier: "iCloud.GitAkademi.exercise").publicCloudDatabase
    private let dbShared = CKContainer(identifier: "iCloud.GitAkademi.exercise").sharedCloudDatabase
    private let dbPrivate = CKContainer(identifier: "iCloud.GitAkademi.exercise").privateCloudDatabase
    
    static let shared = CloudkitManager()
    
    func saveNameItem(name: String,onSuccess:@escaping ()->Void){
        let record = CKRecord(recordType: "MyItem")
        
        record.setValue(name, forKey: "Name")
        
        saveToDB(myrecord: record, dbType: .dbPublic){
            onSuccess()
        }
    }
    
    private func saveToDB(myrecord:CKRecord,dbType: DBType,onSuccess:@escaping ()->Void){

        switch dbType {
        case .dbPublic:
            dbPublic.save(myrecord) { record, error in
                dump(record)
                if record != nil,error == nil{
                    print("saved")
                    onSuccess()
                }
            }
        case .dbPrivate:
            dbPrivate.save(myrecord) { record, error in
                if record != nil,error == nil{
                    print("saved")
                    onSuccess()
                }
            }
        case .dbShared:
            dbShared.save(myrecord) { record, error in
                dump(record)
                if record != nil,error == nil{
                    print("saved")
                    onSuccess()
                }
            }
        }
    }
    
    func fetchItem(recordType:String,onSuccess:@escaping ([Any])->Void){
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        
        dbPublic.perform(query, inZoneWith: nil) { records, error in
            guard let records = records,error == nil else{
                onSuccess([])
                return
            }
            let items = records.compactMap{$0.value(forKey:"Name")}
            
            onSuccess(items)
        }
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

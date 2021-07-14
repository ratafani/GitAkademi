//
//  CDManager.swift
//  CoreData101
//
//  Created by Muhammad Tafani Rabbani on 10/08/20.
//  Copyright © 2020 Muhammad Tafani Rabbani. All rights reserved.
//

import UIKit
import CoreData

struct DataType {
    var name1 : String
    var name2 : String
    var photo : Data
}

class CDManager:NSObject{
    
    var dataType = DataType(name1: "", name2: "", photo: Data())
    
    override init() {
        super.init()
        self.readData()
    }
    
    func readData(){
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileData")
        
        do{
            let res = try context.fetch(fetchRequest)
            
            if res.count > 0{
                let a = res[0] as! NSManagedObject
                
                guard let name1 = a.value(forKey: "firstname") else{
                    return
                }
                self.dataType.name1 = name1 as! String
                
                guard let name2 = a.value(forKey: "secondname")else{
                    return
                }
                self.dataType.name2 = name2 as! String
                
                guard let mPhoto = a.value(forKey: "image") else {
                    return
                }
                self.dataType.photo =  mPhoto as! Data
                
            }else{
                saveData()
                print("Empty")
            }
            
        }
        catch{
            
        }
    }
    
    
    func saveData(){
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        let entity = NSEntityDescription.insertNewObject(forEntityName: "ProfileData", into: context)
        
        entity.setValue(dataType.name1, forKey: "firstname")
        entity.setValue(dataType.name2, forKey: "secondname")
        entity.setValue(dataType.photo, forKey: "image")
    }
    
    func updateData(onSuccess:@escaping ()->Void, onError:@escaping ()->Void ){
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileData")
        
        
        do{
            let res = try context.fetch(fetchRequest)
            
            if res.count > 0{
                let up = res[0] as! NSManagedObject
                up.setValue(dataType.name1, forKey: "firstname")
                up.setValue(dataType.name2, forKey: "secondname")
                up.setValue(dataType.photo, forKey: "image")
                try context.save()
                onSuccess()
            }else{
                saveData()
            }
            
        }
        catch{
            onError()
        }
    }
    
    func deleteData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileData")
        
        do{
            let result = try context.fetch(request)
            if result.count > 0 {
                let result_awal = result[0] as! NSManagedObject
                
                context.delete(result_awal)
                try context.save()
            }else{
                print("Empty")
                saveData()
            }
        }
        catch{
            print("Something wrong")
        }
    }
}

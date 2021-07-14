//
//  ViewController.swift
//  NotificationCenter
//
//  Created by Muhammad Tafani Rabbani on 13/04/20.
//  Copyright © 2020 Muhammad Tafani Rabbani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let mText = UILabel()
    
    var timer = Timer()
    var timer2 = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTimer()
        getNotification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
        self.timer2.invalidate()
    }
    
    @objc func changeBackgroun(){
        let red : CGFloat = .random(in: 0...1)
        let green : CGFloat = .random(in: 0...1)
        let blue : CGFloat = .random(in: 0...1)
        view.backgroundColor = UIColor.init(displayP3Red: red, green: green, blue: blue, alpha: 1)
    }
    
    @objc func counterInc(){
        counter+=1
        mText.text = String(counter)
    }
    
    func updateTimer(){
        //setting up the label
        view.addSubview(mText)
        mText.textColor = .black
        mText.font = .systemFont(ofSize: 50)
        mText.textAlignment = .center
        mText.center = view.center
        mText.frame = view.frame
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeBackgroun), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counterInc), userInfo: nil, repeats: true)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+120) {
            self.timer.invalidate()
            self.timer2.invalidate()
        }
    }
    
    func getNotification(){
        
//        UNUserNotificationCenter.current().delegate = self
        
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Sudah 5 detik oy"
        content.sound = UNNotificationSound.default
        
        
        let myDate = Date().addingTimeInterval(5)
        
        let dateComponent = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: myDate)
        
        
//        let triger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
//        UNTimeIntervalNotificationTrigger
        
        let req = UNNotificationRequest(identifier: "cobaNotif", content: content, trigger: triger)
        
        UNUserNotificationCenter.current().add(req) { (error) in
            if let error = error{
                print("error ",error)
            }
        }
    }
    
    
}


extension ViewController : UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert,.sound])
    }
}

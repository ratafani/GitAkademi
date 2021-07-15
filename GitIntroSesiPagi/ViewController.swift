//
//  ViewController.swift
//  sensors
//
//  Created by Muhammad Tafani Rabbani on 04/07/19.
//  Copyright © 2019 Muhammad Tafani Rabbani. All rights reserved.
//

import UIKit
import CoreMotion

enum sensorName{
    case DeviceMotion
    case Gyro
    case Acceleration
    case Magnet
    case Pedometer
    case Altimeter
}

class ViewController: UIViewController {
    
    var motion = CMMotionManager()
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    let altimeter = CMAltimeter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sensorStart(sensor: sensorName.DeviceMotion)
    }
    
    func sensorStart(sensor name:sensorName){
        switch name {
        case .DeviceMotion:
            if motion.isDeviceMotionAvailable{
                motion.deviceMotionUpdateInterval = 0.05
                motion.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
                    //do something here
                    
                    let angle = self.degrees(radians: (data?.attitude.pitch)!)
                    if angle > 15{
                        self.view.backgroundColor = .red
                    }else{
                        self.view.backgroundColor = .white
                    }
                    print(data?.attitude)
                    
                }
            }
            return
        case .Gyro:
            if motion.isGyroAvailable{
                motion.gyroUpdateInterval = 0.1
                motion.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
                    //do something here
                    
                }
            }
            return
        case .Acceleration:
            if motion.isAccelerometerAvailable{
                motion.accelerometerUpdateInterval = 0.1
                motion.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                    //do something here
                    print(data?.acceleration)
                }
            }
            return
        case .Magnet:
            if motion.isMagnetometerAvailable{
                motion.magnetometerUpdateInterval = 0.1
                motion.startMagnetometerUpdates(to: OperationQueue.current!) { (data, error) in
                    //do something here
                    print(data?.magneticField)
                }
            }
            return
        case .Pedometer:
//            Required NSMotionUsageDescription in plist
            activityManager.startActivityUpdates(to: OperationQueue.current!) { (data) in
                guard let myData = data else { return }
                DispatchQueue.main.async {
                    if myData.walking {
                        print("walking")
                    } else if myData.stationary {
                        print("Stationary")
                    } else if myData.running {
                        print("Running")
                    } else if myData.automotive {
                        print("Automotive")
                    }
                }
            }
            pedometer.startUpdates(from: Date()) { (data, error) in
                print(data?.numberOfSteps)
            }
            return
            
        case .Altimeter:
            if CMAltimeter.isRelativeAltitudeAvailable() {
                altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { (data, error) in
                    print(data?.relativeAltitude)
                }
            }
            return
        }
        
    }
    
    func degrees(radians:Double) -> Double {
        return 180 / .pi * radians
    }
}



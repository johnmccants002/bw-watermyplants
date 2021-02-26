//
//  Notifications.swift
//  WaterMyPlants
//
//  Created by John McCants on 2/25/21.
//

import Foundation
import UIKit
import UserNotifications

extension Notification.Name {
    static var plantUpdated = Notification.Name("PlantSaved")
}

class LocalNotifications {
    
    func waterPlantNotification(plant: Plant, navigationController: UINavigationController) -> UIAlertController? {

        guard let plantName = plant.nickname else {return nil}
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Hey John"
        notificationContent.body = "Time to water \(plantName)"
        notificationContent.badge = NSNumber(value: 1)
        notificationContent.sound = .default

        var timeInterval : Double = 0
        switch plant.frequency {
        case "Once a day":
            timeInterval = 86400
        case "Twice a day":
            timeInterval = 28800
        case "Thrice a day":
            timeInterval = 18000
        case "Often":
            timeInterval = 10
        default:
            break
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error : Error?) in
                            if let error = error {
                                print("Error: \(error)")
                            }
                        }
        
        return alertController(navigationController: navigationController, plantName: plantName, timeInterval: timeInterval)
        
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func alertController(navigationController : UINavigationController, plantName: String, timeInterval: Double) -> UIAlertController {
        var timeIntervalString = ""
        switch timeInterval {
        case 10:
            timeIntervalString = "in 10 seconds"
        case 18000:
            timeIntervalString = "in 4 hours"
        case 28800:
            timeIntervalString = "in 8 hours"
        case 86400:
            timeIntervalString = "by tomorrow"
        default:
            break
        }
        let alertController = UIAlertController(title: "\(plantName) has been watered!", message: "Good job! We'll notify you \(timeIntervalString) to water them again.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            navigationController.popToRootViewController(animated: true)
        }
        alertController.addAction(alertAction)
        return alertController
    }
}


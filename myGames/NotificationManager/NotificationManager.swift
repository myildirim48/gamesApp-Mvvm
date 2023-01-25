//
//  NotificationManager.swift
//  myGames
//
//  Created by YILDIRIM on 25.01.2023.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared=NotificationManager()
    let center = UNUserNotificationCenter.current()

    func createNotfications(title:String,subTitle:String,body:String) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subTitle
        content.body = body
        content.sound = UNNotificationSound.default
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
       
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
        
        
        let category = UNNotificationCategory(identifier: "MyNotificationsCategory", actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        
        
        center.setNotificationCategories([category])
        content.categoryIdentifier = "MyNotificationsCategory"
        
         let identifier = "FirstUserNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                print("Something wrong")
            }
        }
    }
}


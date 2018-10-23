//
//  RichNotificationManager.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit
import UserNotifications

class RichNotificationManager: NSObject {
    
    static let current: RichNotificationManager = {
        let instance = RichNotificationManager()
        return instance
    }()
    
    /// Register user notification - Use at once
    func registerUserNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (permitted, error) in
            if (error != nil) {
                debugPrint("User notification allow status:\(String(describing: error?.localizedDescription))")
            }
            debugPrint("User notification allow status:\(permitted)")
        }
    }
    
    // MARK: - Timesheet Rich notifications
    
    /// Fire local Notification with message string
    func request(categoryID cateID: String,
                                 requestID reqID: String,
                                 threadID thrID: String,
                                 header title: String,
                                 content message: String,
                                 triggerAfter fireAt: TimeInterval,
                                 repeat isRepeat: Bool = false,
                                 soundName soundTitle: String? = nil,
                                 userInfo: [String: Any]?) {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            if settings.authorizationStatus == .authorized {
                
                let notificationContent = UNMutableNotificationContent() // Create Notification Content
                // Configure Notification Content
                notificationContent.categoryIdentifier = cateID
                notificationContent.subtitle = title
                notificationContent.body = message
                notificationContent.sound = UNNotificationSound.default()
                notificationContent.threadIdentifier = thrID
                let triggerAfter = UNTimeIntervalNotificationTrigger(timeInterval: fireAt, repeats: isRepeat)  // Add Trigger schudled notification
              
                if let sound = soundTitle {
                    notificationContent.sound = UNNotificationSound(named: sound) // "water.mp3"
                }
                
                // Create Notification Request
                let request = UNNotificationRequest(identifier: reqID,
                                                    content: notificationContent,
                                                    trigger: triggerAfter)
                
                // Add Request to User Notification Center
                UNUserNotificationCenter.current().add(request) { (error) in
                    if let error = error {
                        debugPrint("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                    } else {
                        debugPrint("Local notification updated.")
                    }
                }
            } else {
                /// Get notification settings
                UIApplication.shared.visibleViewController?.getNotificationAccess()
            }
        }
    }
    
    //MARK: -  Clear Notifications
    
    /**
     Clear pending notifications
     - Parameters:
        - requestIDs: user notification request id
     */
    func clearPendingNotification(requestIDs: [String]? = nil) {
        if let requestedIDs = requestIDs {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: requestedIDs)
        } else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests() // Remove all local notifications
        }
    }
    
    /// Clear all delivered notifications
    func clearAllDeliveredNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}

extension RichNotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.notification.request.content.categoryIdentifier  {
            
        case Constants.Notification.CategoryID.timeSheet:
            // Open Timesheet tap
            UIApplication.shared.visibleViewController?.tabBarController?.selectedIndex = 0
            
        case Constants.Notification.CategoryID.health:
            // Open Health tap
            UIApplication.shared.visibleViewController?.tabBarController?.selectedIndex = 1
        default:
            break
        }
        
    }
}

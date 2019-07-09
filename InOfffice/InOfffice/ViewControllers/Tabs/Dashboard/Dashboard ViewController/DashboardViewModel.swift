//
//  DashboardViewModel.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class DashboardViewModel: NSObject {
    
    var timeSheetLiveUpdated: Timer?
    
    var vehicles: [Vehicle]?
    
    /// Stop timer
    func stopTimer() {
        if let timeSheetTimer = timeSheetLiveUpdated, timeSheetTimer.isValid {
            
            timeSheetLiveUpdated?.invalidate()
            timeSheetLiveUpdated = nil
        }
    }
    
    var totalProductionHoursInSec: Int64 {
        
        var totalHoursInSec: Int64 = 0
        
        if InOfficeManager.current.isUserLoggedIn, let productionHours = InOfficeManager.current.userInfos?.productionHours {
            totalHoursInSec = Int64((productionHours * 60 ) * 60)
        }
        return totalHoursInSec
    }
    
    var workedHoursInSec: Int64 = 0
    
    func fetchTodayWorkedHoursInSec() -> (loggedIn: Date?, loggedOut: Date?, worked: Int64) {
        
        var workedHours: Int64 = 0
        var loggedOutDate : Date?
        var loggedInDate : Date?
        
        if let today = TimeSheetManager.current.today {
            
            TimeSheetManager.current.fetchSummary(today, propertiesToFetch: ["hours"]) { (error, summaries) in
                
                if let err = error {
                    debugPrint(err.localizedDescription)
                    return
                }
                
                if let summarySheet = summaries, summarySheet.count > 0 {
                    workedHours = summarySheet[0].hours
                }
            }
            
            TimeSheetManager.current.fetchData(for: today) { (error, sheetDetails, additionInfos) in
                
                if let detail = sheetDetails, detail.count > 0, let lastObject = detail.last {
                    loggedOutDate = lastObject.getOut
                    loggedInDate = lastObject.getIn
                }
                
            }
        }
        return (loggedInDate, loggedOutDate, workedHours)
    }
    
    // MARK: User notifications
    
    /// schedule notification
    ///
    /// - Parameter isUserLoggedIn: Bool
    func scheduleNotifications(isUserLoggedIn: Bool) {
        
        RichNotificationManager.current.clearPendingNotification(requestIDs: [Constants.Notification.RequestID.takeBreak,
                                                                              Constants.Notification.RequestID.logOut,
                                                                              Constants.Notification.RequestID.takeWater,
                                                                              Constants.Notification.RequestID.comeBackAfterBreak]) // Log out notification removed.
        
        if isUserLoggedIn {
            
            
            breakNotification() // Break notification
            logoutNotification() // set logout notification
            
            /// Health notificaiton
            takeWaterNotification() // set take water notification
            
        } else { // Logged out
            backToWorkNotification()
        }
    }
    
    /// Break notification
    private func breakNotification() {
        
        RichNotificationManager.current.request(categoryID: Constants.Notification.CategoryID.timeSheet,
                                                requestID: Constants.Notification.RequestID.takeBreak,
                                                threadID: "Take a break",
                                                header: "Take a break",
                                                content: "You are worked more that 1 hour 30 mins. 🕜 Please take a break. 🍮",
                                                triggerAfter: TimeInterval(90 * 60),
                                                userInfo: nil)
    }
    
    /// Logout notification
    private  func logoutNotification() {
        // Logout notification
        let logoutAfter = totalProductionHoursInSec - workedHoursInSec
        
        if logoutAfter > 0 {
            RichNotificationManager.current.request(categoryID: Constants.Notification.CategoryID.timeSheet,
                                                    requestID: Constants.Notification.RequestID.logOut,
                                                    threadID: "Shift time was completed",
                                                    header: "Shift time was completed",
                                                    content: "Your today production hours is almost done. 🤝👋 This is right time to logout. 🏍",
                                                    triggerAfter: TimeInterval(logoutAfter),
                                                    soundName: "todayTimeout.wav",
                                                    userInfo: nil)
        }
    }
    
    private func backToWorkNotification() {
        
        RichNotificationManager.current.request(categoryID: Constants.Notification.CategoryID.timeSheet,
                                                requestID: Constants.Notification.RequestID.comeBackAfterBreak,
                                                threadID: "Get back to work",
                                                header: "Get back to work",
                                                content: "Your break was already crossed 10 Mins. 🤷‍♂️ Please go back to work. 👨🏻‍💻",
                                                triggerAfter: TimeInterval(10 * 60),
                                                userInfo: nil)
    }
    
    // MARK: - Health module notifications
    
    /// Take some water notification
    private func takeWaterNotification() {
        
        RichNotificationManager.current.request(categoryID: Constants.Notification.CategoryID.health,
                                                requestID: Constants.Notification.RequestID.takeWater,
                                                threadID: "Take some water",
                                                header: "Health notification",
                                                content: "If you feel hungry, drink some water to fill your stomach. 💧",
                                                triggerAfter: TimeInterval(25 * 60),
                                                repeat: true,
                                                soundName: "water.mp3",
                                                userInfo: nil)
    }
    
}


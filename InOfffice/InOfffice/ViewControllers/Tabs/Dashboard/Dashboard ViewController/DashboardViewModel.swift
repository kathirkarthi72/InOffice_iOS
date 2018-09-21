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
    
}

// MARK: User notifications
extension DashboardViewModel {
    
    func scheduleNotifications(isUserLoggedIn: Bool) {
     
        if isUserLoggedIn {
            // Break notification
            RichNotificationManager.current.clearPendingNotification(requestIDs: [Constants.Notification.RequestID.comeBackAfterBreak]) // Break notification removed.
            
            RichNotificationManager.current.requestRichNotification(categoryID: Constants.Notification.CategoryID.timeSheet,
                                                                    requestID: Constants.Notification.RequestID.takeBreak,
                                                                    header: "Take a break",
                                                                    content: "You are worked more that 1 hour 30 mins. please take a break",
                                                                    triggerAfter: TimeInterval(90 * 60),
                                                                    userInfo: nil)
            
            // Logout notification
            let logoutAfter = totalProductionHoursInSec - workedHoursInSec
            
            RichNotificationManager.current.requestRichNotification(categoryID: Constants.Notification.CategoryID.timeSheet,
                                                                    requestID: Constants.Notification.RequestID.logOut,
                                                                    header: "Shift time was completed",
                                                                    content: "Your today production hours is almost done. This is right time to logout",
                                                                    triggerAfter: TimeInterval(logoutAfter),
                                                                    userInfo: nil)
        } else { // Logged out
            RichNotificationManager.current.clearPendingNotification(requestIDs: [Constants.Notification.RequestID.logOut]) // Log out notification removed.
            
            RichNotificationManager.current.requestRichNotification(categoryID: Constants.Notification.CategoryID.timeSheet,
                                                                    requestID: Constants.Notification.RequestID.comeBackAfterBreak,
                                                                    header: "Get back to work",
                                                                    content: "Your break was already crossed 10 Mins. Please go back to work.",
                                                                    triggerAfter: TimeInterval(10 * 60),
                                                                    userInfo: nil)
        }
    }
    
}

//
//  Constancts.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import Foundation

/// Constants
struct Constants {
    
    /// Navigation segues
    struct Segues {
        
        /// Dashboard viewController
        struct Dashboard {
            
            /// Navigate to initial VC
            static let toInitialVC = "ShowSigninPage"
            
            /// Navigate to Timesheet history VC
            static let toTimesheetHistory = "ShowTimesheetHistoryPage"
            
            static let toTodayHistory = "toTodayHistory"
            
            /// Navigate to Mileage history VC
            static let toMileageHistory = "mileageSegue"
            
            struct TimeSheetHistory {
                static let toNotes = "goToNotesScene"
                
                static let toDetail = "toTimesheetHistoryDetails"
            }
        }
        
        struct Vehicle {
            
            struct History {
                
                static let  updateFuelInfo = "fuelInfoSegue"
                
                static let  addFuelInfo = "addFuelSegue"
            }
        }
    }
    
    /// User Notification
    struct Notification {
        
        /// Notification category id
        struct CategoryID {
            
            /// Timesheet
            static let timeSheet = "timesheet"
            
            /// Health
            static let health = "health"
        }
        
        
        /// Request id
        struct RequestID {
            
            /// Logout
            static let logOut = "today_logout"
            
            /// Take break
            static let takeBreak = "take_break"
            
            /// Come back after break
            static let comeBackAfterBreak = "break_time_over"
            
            /// Take water
            static let takeWater = "take_some_water"
        }
        
        
        /// Drink water actions
        struct DrinkWaterActions {
            
            /// 100 ML
            static let first = "100 ML"
            
            /// 200 ML
            static let second = "200 ML"

            /// 300 ML
            static let third = "300 ML"
            
            /// 400 ML
            static let fourth = "400 ML"
            
            /// 500 ML
            static let fivth = "500 ML"
        }
    }
}

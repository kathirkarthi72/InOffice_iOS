//
//  Constancts.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Segues {
        struct Dashboard {
            static let toInitialVC = "ShowSigninPage"
            
            static let toTimesheetHistory = "ShowTimesheetHistoryPage"
        }
    }
    
    struct Notification {
        struct CategoryID {
            static let timeSheet = "timesheet"
            
            static let health = "health"
        }
        
        struct RequestID {
            
            static let logOut = "today_logout"
            
            static let takeBreak = "take_break"
            
            static let comeBackAfterBreak = "break_time_over"
            
            static let takeWater = "take_some_water"
        }
        
        struct DrinkWaterActions {
            
            static let first = "100 ML"
            
            static let second = "200 ML"

            static let third = "300 ML"
            
            static let fourth = "400 ML"
            
            static let fivth = "500 ML"

        }
    }
}

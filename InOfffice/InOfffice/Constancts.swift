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
        }
        
        struct RequestID {
            
            static let logOut = "today_logout"
            
            static let takeBreak = "take_break"
            
            static let comeBackAfterBreak = "break_time_over"
        }
    }
}

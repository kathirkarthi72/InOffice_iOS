//
//  StringExtension.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import Foundation

extension String {
    
    var toDate: Date {
        let dateFormatter = CustomDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm:ss aa" // Your date format
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") // Current time zone
        
        let serverDate: Date = dateFormatter.date(from: self)! // according to date format your date string
        return serverDate
    }
    
    var toDateOnly: String {
        
        let dateFormatter = CustomDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm:ss aa" // Your date format
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") // Current time zone
        let serverDate: Date = dateFormatter.date(from: self)! // according to date format your date string
        
        dateFormatter.dateFormat = "dd-MMM-yyyy" // Your New Date format as per requirement change it own
        
        let newDate: String = dateFormatter.string(from: serverDate) // pass Date here
        return newDate
    }
    
    var toTimeOnly: String {
        
        let dateFormatter = CustomDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm:ss aa" // Your date format
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") // Current time zone
        let serverDate: Date = dateFormatter.date(from: self)! // according to date format your date string
        
        dateFormatter.dateFormat = "hh:mm:ss aa" // Your New Date format as per requirement change it own
        
        let newDate: String = dateFormatter.string(from: serverDate) // pass Date here
        
        return newDate
    }
   
}

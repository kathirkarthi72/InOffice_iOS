//
//  DateExtension.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import Foundation

extension Date {
    
    /// Convert Date to String
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm:ss aa" // Your New Date format as per requirement change it own
        
        let newDate: String = dateFormatter.string(from: self) // pass Date here
        return newDate
    }
}

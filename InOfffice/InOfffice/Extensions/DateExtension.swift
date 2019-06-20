//
//  DateExtension.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import Foundation

extension Date {
    
    /// Convert type
    ///
    /// - withMonthNumber: Date with month as number with time
    /// - withMonthName: Date with month as name with time
    /// - toDateOnly: Date only
    enum ConvertType: String {
        case withMonthNumber = "dd-MM-yyyy hh:mm:ss aa"
        case withMonthName = "dd-MMM-yyyy hh:mm:ss aa"
        case toDateOnly = "dd-MM-yyyy"
    }
    
    /// Convert Date to String
    ///
    /// - Parameter type: converty type
    /// - Returns: date in string value
    func convert(_ type: ConvertType = .withMonthName) -> String {
        let dateFormatter = CustomDateFormatter()
        dateFormatter.dateFormat = type.rawValue // Your New Date format as per requirement change it own
        
        let newDate: String = dateFormatter.string(from: self) // pass Date here
        return newDate
    }
}

/// Custom date formatter. Calendar updated.
class CustomDateFormatter: DateFormatter {
    
    override init() {
        super.init()
        
        let calendar = Calendar(identifier: .gregorian)
        self.calendar = calendar
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

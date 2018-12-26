//
//  DateExtension.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import Foundation

extension Date {
    
    enum ConvertType: String {
        case withMonthNumber = "dd-MM-yyyy hh:mm:ss aa"
        case withMonthName = "dd-MMM-yyyy hh:mm:ss aa"
        case toDateOnly = "dd-MM-yyyy"
    }
    
    /// Convert Date to String
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
        
        var calendar = Calendar(identifier: .gregorian)
        self.calendar = calendar
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

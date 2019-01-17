//
//  IntExtension.swift
//  InOfffice
//
//  Created by ktrkathir on 03/09/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import Foundation

extension Int64 {
    
    /// Seconds to hours minitues and seconds
    ///
    /// - Returns: string value
    func secondsToHoursMinutesSeconds() -> String {
        let zero : Int64 = 0
        
        if self > zero {
            let time = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
            return "\(time.0)h \(time.1)m \(time.2)s"
        } else {
            return "\(0)h \(0)m \(0)s"
        }
    }    
}

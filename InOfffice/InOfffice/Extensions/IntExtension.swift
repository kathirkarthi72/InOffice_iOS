//
//  IntExtension.swift
//  InOfffice
//
//  Created by ktrkathir on 03/09/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import Foundation

extension Int64 {
    
    func secondsToHoursMinutesSeconds() -> String {
        let time = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
        return "\(time.0)h \(time.1)m \(time.2)s"
    }
}

//
//  TimeSheetManager.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class TimeSheetManager: NSObject {

    static let current = TimeSheetManager()

    var userDefault = UserDefaults.init(suiteName: "group.com.ktrkathir.InOfffice.InOffice-TimeSheet")

    let productionHourString: [String] = ["30m", "1h", "1h 30m", "2h", "2h 30m", "3h", "3h 30m", "4h", "4h 30m", "5h", "5h 30m", "6h", "6h 30m", "7h", "7h 30m", "8h", "8h 30m", "9h", "9h 30m", "10h", "10h 30m", "11h", "11h 30m", "12h"]
    
    let productionHourList: [Float] = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10, 10.5, 11.0, 11.5, 12.0]
}

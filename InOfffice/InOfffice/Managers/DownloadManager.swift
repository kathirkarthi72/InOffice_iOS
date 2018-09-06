//
//  DownloadManager.swift
//  InOfffice
//
//  Created by ktrkathir on 06/09/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class DownloadManager: NSObject {
    
    static let current = DownloadManager()
    
    var filePath: URL {
        let fileName = "Timesheet.csv"
        let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        return path
    }
    /*
    var generateInputs: String? {
        var inputs = "Date,In Time,Out Time,Production hours\n"
        
        guard let fetchedSheets = TimeSheetManager.current.fetchAllData() else { return nil }
        
        for sheet in fetchedSheets {
            
            var todayDate: String = ""

            if let date = sheet.sheetID { // Date
                inputs.append("\n\(date)\n")
            }
            /*
            var totalInterval: TimeInterval = TimeInterval()
            
            for item in sheet {
                
                let startTime = item["start"] as! String
                let endTime = item["stop"] as! String
                
                let currentDate = startTime.toDateOnly
                if todayDate != currentDate {
                    
                    inputs.append(currentDate)
                }
                
                var duration: String = ""
                
                if let interval = item["interval"] as? TimeInterval {
                    
                    totalInterval += interval
                    
                    let intervalTime = TimeSheetManager.current.secondsToHoursMinutesSeconds(seconds: Int(interval))
                    
                    duration = String(format: "%d:%d:%d", intervalTime.0, intervalTime.1, intervalTime.2)
                }
                
                let newLine = String.init(format: ",%@,%@,%@\n", startTime.toTimeOnly, endTime.toTimeOnly, duration)
                inputs.append(newLine)
            }
            
            let intervalTime = TimeSheetManager.current.secondsToHoursMinutesSeconds(seconds: Int(totalInterval))
            let productionHour = String(format: "%d:%d:%d", intervalTime.0, intervalTime.1, intervalTime.2)
            
            inputs.append(",,,\(productionHour)")
            */
            inputs.append("\n\n")
        }
        
        return inputs
    }*/
    
}

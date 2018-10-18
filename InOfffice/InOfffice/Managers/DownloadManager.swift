//
//  DownloadManager.swift
//  InOfffice
//
//  Created by ktrkathir on 06/09/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit
import CoreData

class DownloadManager: NSObject {
    
    static let current = DownloadManager()
    
    var filePath: URL {
        let fileName = "Timesheet.csv"
        let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        return path
    }
    
    func crateFile(timeSheets: [TimeSheetDetails]) -> String {
        var inputs = "Date,In Time,Out Time,Production hours\n"
        
        if timeSheets.count > 0 {
            
            var totalTime: Int64 = 0
            var todayDate: String?

            timeSheets.forEach { (sheet) in
                
                if let date = sheet.sheetID { // Date
                    
                    if todayDate != nil {
                        inputs.append("\n")
                        
                        if todayDate != date {
                            
                            inputs.append(",,,\(totalTime.secondsToHoursMinutesSeconds())\n")
                            
                            todayDate = date
                            totalTime = 0
                            
                            inputs.append(date)
                        }
                    } else {
                        todayDate = date
                        inputs.append(date)
                    }
                }
                
                if let startTime = sheet.getIn?.convert(), let endTime = sheet.getOut?.convert() {
                    
                    totalTime += sheet.productionHours
                    
                    let combined = "\n" + "," + startTime + "," + endTime + "," + sheet.productionHours.secondsToHoursMinutesSeconds()
                    inputs.append(combined)
                }
            }
            inputs.append(",,,\(totalTime.secondsToHoursMinutesSeconds())")
        }
        
        return inputs
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

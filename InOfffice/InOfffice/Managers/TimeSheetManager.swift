//
//  TimeSheetManager.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit
import CoreData

class TimeSheetManager: NSObject {
    
    static let current = TimeSheetManager()
    
    var userDefault = UserDefaults.init(suiteName: "group.com.ktrkathir.InOfffice.InOffice-TimeSheet")
    
    let productionHourString: [String] = ["30m", "1h", "1h 30m", "2h", "2h 30m", "3h", "3h 30m", "4h", "4h 30m", "5h", "5h 30m", "6h", "6h 30m", "7h", "7h 30m", "8h", "8h 30m", "9h", "9h 30m", "10h", "10h 30m", "11h", "11h 30m", "12h"]
    
    let productionHourList: [Float] = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10, 10.5, 11.0, 11.5, 12.0]
    
    // Today sheet ID
    var today: String? {
        get {
            return UserDefaults.standard.string(forKey: "TimeSheet_Today")
        } set {
            UserDefaults.standard.set(newValue, forKey: "TimeSheet_Today")
        }
    }
    
    /// Is user get in to office.
    var isGetIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "TimeSheet_Today_GetIn")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "TimeSheet_Today_GetIn")
        }
    }

    /// Create New record
    func createNewRecord(withSave save: Bool) {
        
        if save { // Save Record
            today = nil
        } else { // Create record only. Delete today records from summary and timesheetDetail
            if let today = today {
                trashDetail(today)
                trashSummary(today)
            }
        }
    }
}

// MARK: - CoreData Manager
extension TimeSheetManager {
    
    var objectContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    /*
     var fetchFromTimeSheetEntity : NSFetchRequest<TimeSheet> {
     return NSFetchRequest<TimeSheet>(entityName: "TimeSheet")
     }
     */
    
    /// Delete all datas from Timesheet Table
    func trashAllData() {
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: TimeSheetDetails.fetchRequest())
        do {
            try objectContext?.execute(deleteRequest)
            
            if let context = objectContext {
                try context.save()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// trash TimesheetDetails with sheetID
    func trashDetail(_ sheedID: String) {
        
        let fetchRequest: NSFetchRequest = TimeSheetDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "sheedID = %@", sheedID)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: TimeSheetDetails.fetchRequest())
        do {
            try objectContext?.execute(deleteRequest)
            
            if let context = objectContext {
                try context.save()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Insert Data from Timesheet
    func insertShiftInData() {
        
        if let context = objectContext {
            let newRecord = TimeSheetDetails(context: context)
            // newRecord.date = Date()
            newRecord.getIn = Date()
            newRecord.sheetID = today
            newRecord.notes = "New Day"
            do {
                try context.save()
                
                createNewSummary(with: Date())
                
            } catch let error {
                print("Unable to save ShiftIn Data: \(error.localizedDescription)")
            }
        }
    }
    
    func updateShiftOutData() {
        
        if let fetchedData = fetchAllData() {
            
            if let last = fetchedData.last {
                
                let now = Date()
                if let getIn = last.getIn {
                    
                    let timeInterval = now.timeIntervalSince(getIn)
                    last.productionHours = Int64(timeInterval)
                    
                    last.getOut = now
                    
                    if let context = objectContext {
                        do {
                            try context.save()
                            
                            if let today = today {
                                updateSummary(id: today, outTime: now, lastWorkedHours: last.productionHours)
                            }
                            
                        } catch let error {
                            print("Unable to save ShiftIn Data: \(error.localizedDescription)")
                        }
                    }
                }
            }
            
            /*  if let context = objectContext {
             
             let newRecord = TimeSheet(context: context)
             newRecord.getOut = Date()
             newRecord.productionHours = "5"
             newRecord.notes = "New Day"
             }
             */
        }
    }
    
}

// MARK: - Fetch from Core Data
extension TimeSheetManager {
    
    /// FetchDataError
    enum FetchDataError: Error {
        case invalidSheetId
        case failedToFetch
    }
    
    /// Fetch Data by ID
    func fetchData(for sheetID: String, completed: @escaping (FetchDataError?, [TimeSheetDetails]?, AdditionalInfo? ) -> ()) {
        
        if sheetID.isEmpty {
            completed(FetchDataError.invalidSheetId, nil, nil)
        }
        
        let fetchRequest: NSFetchRequest = TimeSheetDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "sheetID = %@", sheetID)
        
        let getInSort = NSSortDescriptor(key: "getIn", ascending: true)
        fetchRequest.sortDescriptors = [getInSort]
        
        if let context = objectContext {
            do {
                let timeSheets = try context.fetch(fetchRequest)
                
                completed(nil, timeSheets, timeSheets.getAdditionalInfos())
            } catch let error {
                print("Failed to fetch a record from Timesheet: \(error.localizedDescription)")
                completed(FetchDataError.failedToFetch, nil, nil)
            }
        }
    }
    
    /// Fetch all Data from Timesheet
    func fetchAllData() -> [TimeSheetDetails]? {
        
        let fetchRequest: NSFetchRequest = TimeSheetDetails.fetchRequest()
        let sheetSort = NSSortDescriptor(key: "sheetID", ascending: false)
        let getInSort = NSSortDescriptor(key: "getIn", ascending: true)
        
        fetchRequest.sortDescriptors = [sheetSort, getInSort]
        
        if let context = objectContext {
            do {
                let timeSheets = try context.fetch(fetchRequest)
                return timeSheets
            } catch let error {
                print("Failed to fetch a record from Timesheet: \(error.localizedDescription)")
            }
        }
        
        return nil
    }
}

// MARK: - TimeSheet summary
extension TimeSheetManager {
    
    /// Create New Summary sheet on timesheet Summary
    func createNewSummary(with inTime: Date) {
        
        guard let today = today else { return }
        
        fetchSummary(today) { (error, summaries) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let summaries = summaries, summaries.count > 0, let _ = summaries.first {
               print("Already created.") // Do nothing.
                return
            } else { // Not exist.
                
                if let context = self.objectContext {
                    
                    let newSheet = TimeSheetSummary(context: context)
                    newSheet.sheetID = today
                    newSheet.inTime = inTime
                    
                    do {
                        try context.save()
                    } catch let error {
                        print("Unable to Create new sheet: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    /// Fetch all summary report
    func fetchAllSummary(completed: @escaping (FetchDataError?, [TimeSheetSummary]?) -> ()) {
       
        let fetchRequest: NSFetchRequest = TimeSheetSummary.fetchRequest()
        
        if let context = objectContext {
            do {
                let summaries = try context.fetch(fetchRequest)
                completed(nil, summaries)
            } catch let error {
                print("Failed to fetch a record from Timesheet: \(error.localizedDescription)")
                completed(FetchDataError.failedToFetch, nil)
            }
        }
    }
    
    func fetchSummary(_ sheetID: String, completed: @escaping (FetchDataError?, [TimeSheetSummary]?) -> ()) {
        
        if sheetID.isEmpty {
            completed(FetchDataError.invalidSheetId, nil)
        }
        
        let fetchRequest: NSFetchRequest = TimeSheetSummary.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "sheetID = %@", sheetID)
      
        if let context = objectContext {
            do {
                let summary = try context.fetch(fetchRequest)
                
                completed(nil, summary)
            } catch let error {
                print("Failed to fetch a record from Timesheet: \(error.localizedDescription)")
                completed(FetchDataError.failedToFetch, nil)
            }
        }
    }
    
    /// Update summary Sheet with OutTime and Last workedHours
    func updateSummary(id sheetID: String, outTime: Date, lastWorkedHours: Int64) {
        
        fetchSummary(sheetID) { (error, summaries) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let fetchedSummaries = summaries, fetchedSummaries.count > 0, let firstObject = fetchedSummaries.first else { return }
            
            firstObject.outTime = outTime
            firstObject.hours += lastWorkedHours
            
            if let context = self.objectContext {
                do {
                    try context.save()
                } catch let error {
                    print("Unable to save ShiftIn Data: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Trash all summary records
    func trashAllSummary() {
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: TimeSheetSummary.fetchRequest())
        do {
            try objectContext?.execute(deleteRequest)
            
            if let context = objectContext {
                try context.save()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// trashSummary with sheetID
    func trashSummary(_ sheedID: String) {
        
        let fetchRequest: NSFetchRequest = TimeSheetSummary.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "sheedID = %@", sheedID)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: TimeSheetSummary.fetchRequest())
        do {
            try objectContext?.execute(deleteRequest)
            
            if let context = objectContext {
                try context.save()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

}

/// Additional informations of timesheet day details
struct AdditionalInfo {
    
    let sheetID: String?
    let getIn: Date?
    let getOut: Date?
    var workedHours: Int64 = 0
}

// MARK: - Array where element of Timesheet
extension Array where Element == TimeSheetDetails {
    
    func getAdditionalInfos() -> AdditionalInfo? {
        
        if self.count > 0 {
            
            let hours = self.map({$0.productionHours})
            
            let workedHours: Int64 = hours.reduce(0, { $0 + $1})
            
            return AdditionalInfo(sheetID: self.first?.sheetID,
                                  getIn: self.first?.getIn,
                                  getOut: self.first?.getOut,
                                  workedHours: workedHours)
        }
        return nil
    }
}



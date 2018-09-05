//
//  TimeSheetDetailViewModel.swift
//  InOfffice
//
//  Created by ktrkathir on 03/09/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class TimeSheetDetailViewModel: NSObject {

    var details: [TimeSheetDetails]?
    
    var additionalInfo: AdditionalInfo?
    
    func fetchDetail(sheedID: String) {
        
        TimeSheetManager.current.fetchData(for: sheedID) { (error, timeSheets, additionalInfos) in
        
            if let err = error {
                print("Error: \(err.localizedDescription)")
            }
            
            self.details = timeSheets
            self.additionalInfo = additionalInfos
        }
    }
    
    /// Update history Detail cell
    func updateHistoryDetail( cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
        
        let inTime = cell.contentView.viewWithTag(1) as! UILabel
        let outTime = cell.contentView.viewWithTag(2) as! UILabel
        let totalTime = cell.contentView.viewWithTag(3) as! UILabel

        if let detail = details {
            
            inTime.text = detail[indexPath.row].getIn?.convert()
            outTime.text = detail[indexPath.row].getOut?.convert()
            totalTime.text = detail[indexPath.row].productionHours.secondsToHoursMinutesSeconds()
        }
        
        return cell
    }
}

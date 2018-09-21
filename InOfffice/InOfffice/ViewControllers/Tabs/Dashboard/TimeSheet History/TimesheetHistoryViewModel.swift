//
//  TimesheetHistoryViewModel.swift
//  InOfffice
//
//  Created by ktrkathir on 28/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class TimesheetHistoryViewModel: NSObject {
   
    /// Today history
    var today: TimeSheetSummary?
    
    /// Older History
    var olders: [TimeSheetSummary]?
    
    /// Update history Detail cell
    func updateHistory(cell: UITableViewCell, indexPath: IndexPath, detail: TimeSheetSummary) -> UITableViewCell {
        
        let inTime = cell.contentView.viewWithTag(1) as! UILabel
        let outTime = cell.contentView.viewWithTag(2) as! UILabel
        let totalTime = cell.contentView.viewWithTag(3) as! UILabel
        
        inTime.text = detail.inTime?.convert()
        outTime.text = detail.outTime?.convert()
        totalTime.text = detail.hours.secondsToHoursMinutesSeconds()
        
        return cell
    }
}

//
//  TimesheetHistoryViewModel.swift
//  InOfffice
//
//  Created by ktrkathir on 28/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class TimesheetHistoryViewModel: NSObject {
   
    /// Timesheet past History
    var summaries: [TimeSheetSummary]?
    
    /// Update history Detail cell
    func updateHistory( cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
        
        let inTime = cell.contentView.viewWithTag(1) as! UILabel
        let outTime = cell.contentView.viewWithTag(2) as! UILabel
        let totalTime = cell.contentView.viewWithTag(3) as! UILabel
        
        if let detail = summaries {
            
            inTime.text = detail[indexPath.row].inTime?.convert()
            outTime.text = detail[indexPath.row].outTime?.convert()
            totalTime.text = detail[indexPath.row].hours.secondsToHoursMinutesSeconds()
        }
        
        return cell
    }
}

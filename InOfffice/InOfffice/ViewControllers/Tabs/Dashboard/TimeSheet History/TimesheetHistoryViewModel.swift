//
//  TimesheetHistoryViewModel.swift
//  InOfffice
//
//  Created by ktrkathir on 28/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit
import Foundation

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
        
        cell.contentView.subviews[0].backgroundColor = UIColor.dynamicColor(secs: detail.hours)        
        return cell
    }
    
    var totalProductionHoursInSec: Int64 {
        
        var totalHoursInSec: Int64 = 0
        
        if InOfficeManager.current.isUserLoggedIn, let productionHours = InOfficeManager.current.userInfos?.productionHours {
            totalHoursInSec = Int64((productionHours * 60 ) * 60)
        }
        return totalHoursInSec
    }
}

/*
 extension UIView {
 
 /// Setting gradienet color to Book button
 fileprivate func gradientColor(from: UIColor, to: UIColor, percentage: CGFloat) {
 
 let reminding = 100 - percentage
 
 let done = percentage / 100.0
 let on = reminding / 100.0
 
 let gradientLayer = CAGradientLayer()
 gradientLayer.frame = frame
 gradientLayer.colors = [from.cgColor, to.cgColor]
 gradientLayer.startPoint = CGPoint(x: 0.0, y: done)
 gradientLayer.endPoint = CGPoint(x: done, y: on)
 // gradientLayer.cornerRadius = 22
 
 // Render the gradient to UIImage
 UIGraphicsBeginImageContext(gradientLayer.bounds.size)
 gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
 let image = UIGraphicsGetImageFromCurrentImageContext()
 UIGraphicsEndImageContext()
 
 (subviews[0] as! UIImageView).image = image
 }
 
 }
 
 */

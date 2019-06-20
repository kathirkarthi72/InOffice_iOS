//
//  TimesheetNotesViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 24/10/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class TimesheetNotesViewController: UIViewController {
    
    /// Edit time sheet details
    var editSheet: TimeSheetDetails?
    
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var customToolBar: UIToolbar!
    
    @IBOutlet weak var inoutTimeButton: UIButton!
    @IBOutlet weak var workedButton: UIButton!
    
    fileprivate func initalSetup() {
        
        if let inTime = editSheet?.getIn {
            let attributedTitle = NSMutableAttributedString(string: "InTime : ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
            let attributedValue1 = NSAttributedString(string: inTime.convert(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            let attributedTitle2 = NSAttributedString(string: "\nOutTime : ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
            
            attributedTitle.append(attributedValue1)
            attributedTitle.append(attributedTitle2)
            
            if let outTime = editSheet?.getOut {
                let attributedValue2 = NSAttributedString(string: outTime.convert(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                
                attributedTitle.append(attributedValue2)
            }
            
            inoutTimeButton.setAttributedTitle(attributedTitle, for: .normal)
            inoutTimeButton.titleLabel?.numberOfLines = 2
        }
        
        if let worked = editSheet?.productionHours {
            let attributedTime = NSMutableAttributedString(string: "Worked : ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
            let attributedTime1 = NSAttributedString(string: worked.secondsToHoursMinutesSeconds(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            
            attributedTime.append(attributedTime1)
            
            workedButton.setAttributedTitle(attributedTime, for: .normal)
        }
        
        if let notes = editSheet?.notes {
            notesTextView.text = notes
        }
        
        notesTextView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initalSetup()
    }
    
    @IBAction func cancelBarButtonAction(_ sender: Any) {
        UIImpactFeedbackGenerator().impactOccurred()

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBarButtonAction(_ sender: Any) {
        UIImpactFeedbackGenerator().impactOccurred()

        editSheet?.notes = notesTextView.text
        TimeSheetManager.current.updateSheetDetails()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     
     if segue.identifier == "showIntevalPicker" {
     let intervalPicker = segue.destination as! IntervalPickerViewController
     intervalPicker.isDownload = false
     
     if let inTime = editSheet?.getIn, let outTime = editSheet?.getOut, let worked = editSheet?.productionHours {
     intervalPicker.minmumDate = inTime
     intervalPicker.maximumDate = outTime
     
     intervalPicker.tempProductionHours = worked
     
     intervalPicker.picked(completed: { (from, to) in
     // self.downloadRecord(from: from, to: to)
     })
     }
     }
     }
     */
}


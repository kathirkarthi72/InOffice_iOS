//
//  TimesheetHistoryViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 28/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class TimesheetHistoryViewController: UIViewController {
    
    @IBOutlet var timesheetHistoryViewModel: TimesheetHistoryViewModel!
    
    /// UITableView
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TimeSheetManager.current.fetchAllSummary { (error, fetchedSummaries) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            
            guard var summaries = fetchedSummaries else { return }
            
            if let firstObject = summaries.first, let today = TimeSheetManager.current.today, firstObject.sheetID == today {
                self.timesheetHistoryViewModel.today = summaries.removeFirst()
            }
            
            self.timesheetHistoryViewModel.olders = summaries
            
            DispatchQueue.main.async {
                self.historyTableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     func fetchSheet(_ byID: String) {
     
     TimeSheetManager.current.fetchData(for: byID) { (error, sheets, additionalInfos) in
     
     if let err = error {
     debugPrint(err.hashValue)
     }
     }
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toTimesheetHistoryDetails" {
            let detailVC = segue.destination as! TimeSheetDetailViewController
            detailVC.cameBy = .history
            if sender != nil {
                let sheetID = sender as? String
                detailVC.sheedID = sheetID
            }
        }
        
    }
    
    //MARK: - Bar button aciton
    
    @IBAction func deleteBarButtonClickedAction(_ sender: Any) {
        
        let sheet = UIAlertController(title: "Delete all records", message: nil, preferredStyle: .actionSheet)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { (okAction) in
           
            TimeSheetManager.current.trashDetail(sheetID: nil)
            
            self.timesheetHistoryViewModel.today = nil
            self.timesheetHistoryViewModel.olders = nil
            TimeSheetManager.current.today = nil
            
            DispatchQueue.main.async {
                self.historyTableView.reloadData()
            }
        }
        sheet.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cancelAction)
        
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    @IBAction func downloadBarButtonClickedAction(_ sender: Any) {
    }
}

// MARK: TableView data source
extension TimesheetHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Today"
        default: // Older
            return "Older"
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if self.timesheetHistoryViewModel.today != nil {
                return 1
            }
        default: // Older
            if let olders = self.timesheetHistoryViewModel.olders {
                return olders.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        
        let presentationView = cell.contentView.subviews[0]
        presentationView.layer.cornerRadius = 5.0
        
        switch indexPath.section {
        case 0:
            if let today = self.timesheetHistoryViewModel.today {
                return timesheetHistoryViewModel.updateHistory(cell: cell, indexPath: indexPath, detail: today)
            }
        default: // Older
            if let olders = self.timesheetHistoryViewModel.olders {
                return timesheetHistoryViewModel.updateHistory(cell: cell, indexPath: indexPath, detail: olders[indexPath.row])
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            if let today = self.timesheetHistoryViewModel.today {
                self.performSegue(withIdentifier: "toTimesheetHistoryDetails", sender: today.sheetID)
            }
        default: // Older
            if let olders = self.timesheetHistoryViewModel.olders {
                self.performSegue(withIdentifier: "toTimesheetHistoryDetails", sender: olders[indexPath.row].sheetID)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1 ? true : false // Today : // Older
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete, indexPath.section == 1 { // Older
            
            if let older = self.timesheetHistoryViewModel.olders, let sheedID = older[indexPath.row].sheetID {
                
                TimeSheetManager.current.trashSummary(sheetID: sheedID)
                
                self.timesheetHistoryViewModel.olders?.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        }
    }
}


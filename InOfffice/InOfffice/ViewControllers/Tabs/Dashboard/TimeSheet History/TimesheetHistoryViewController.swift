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
                print(error.localizedDescription)
            }
            
            guard let summaries = fetchedSummaries else { return }
            
            self.timesheetHistoryViewModel.summaries = summaries
            
            DispatchQueue.main.async {
                self.historyTableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchSheet(_ byID: String) {
        
        TimeSheetManager.current.fetchData(for: byID) { (error, sheets, additionalInfos) in
            
            if let err = error {
                print(err.hashValue)
            }
        }
    }
    
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
    }
    
    @IBAction func downloadBarButtonClickedAction(_ sender: Any) {
    }
}

// MARK: TableView data source
extension TimesheetHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let summaries = self.timesheetHistoryViewModel.summaries {
            return summaries.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        
        let presentationView = cell.contentView.subviews[0]
        presentationView.layer.cornerRadius = 5.0
        
        return timesheetHistoryViewModel.updateHistory(cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let selectedsummary = timesheetHistoryViewModel.summaries![indexPath.row]
        self.performSegue(withIdentifier: "toTimesheetHistoryDetails", sender: selectedsummary.sheetID)
    }
}


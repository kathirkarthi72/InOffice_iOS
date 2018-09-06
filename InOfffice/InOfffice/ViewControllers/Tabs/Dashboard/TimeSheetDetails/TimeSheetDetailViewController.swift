//
//  TimeSheetDetailViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 03/09/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

enum CameBy {
    case dashBoard
    case history
}

class TimeSheetDetailViewController: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    
    @IBOutlet var detailViewModel: TimeSheetDetailViewModel!
    
    /// Sheet ID
    var sheedID : String?
    
    /// Came by
    var cameBy: CameBy = .dashBoard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cameBy == .history {
          self.navigationItem.rightBarButtonItems?.remove(at: 0)
        }

        if let sheedID = sheedID, !sheedID.isEmpty {
            detailViewModel.fetchDetail(sheedID: sheedID)
        }
        
        DispatchQueue.main.async {
            self.detailTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Button Action
    @IBAction func createNewSheetBarButtonAction(_ sender: Any) {
        
        if TimeSheetManager.current.isGetIn {
            
            let sheet = UIAlertController(title: "Your in office", message: "Make you are logged out?", preferredStyle: .actionSheet)
            
            let logoutAction = UIAlertAction(title: "Logout Now", style: .default) { (okAction) in
               
                if TimeSheetManager.current.today == nil {
                    TimeSheetManager.current.today = Date().convert(.toDateOnly)
                }
                
                if let sheedID = TimeSheetManager.current.today, !sheedID.isEmpty {
                    
                    TimeSheetManager.current.updateShiftOutData(toSheet: sheedID)
                    
                    self.detailViewModel.fetchDetail(sheedID: sheedID)
                    
                    DispatchQueue.main.async {
                        self.detailTableView.reloadData()
                    }
                }
            }
            sheet.addAction(logoutAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            sheet.addAction(cancelAction)
            
            self.present(sheet, animated: true, completion: nil)
        } else {
            let sheet = UIAlertController(title: "Create new sheet", message: "Check your reminding hours before creating new sheet.", preferredStyle: .actionSheet)
            
            let saveCreateAction = UIAlertAction(title: "Save & Create", style: .default) { (okAction) in
                TimeSheetManager.current.createNewRecord(withSave: true)
                
                self.navigationController?.popViewController(animated: true)
            }
            sheet.addAction(saveCreateAction)
            
            let createAction = UIAlertAction(title: "Create only", style: .default) { (okAction) in
                TimeSheetManager.current.createNewRecord(withSave: false)
                
            }
            sheet.addAction(createAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            sheet.addAction(cancelAction)
            
            self.present(sheet, animated: true, completion: nil)
        }
    }
    
    @IBAction func downloadBarButtonAction(_ sender: Any) {
        
    }
    
}

extension TimeSheetDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let detail = detailViewModel.details {
            return detail.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0: // first cell
            return 80
            
        case ((detailViewModel.details?.count)! - 1): // last cell
            return 80
        default: // middle cell
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0: // first cell
            let firstCell = tableView.dequeueReusableCell(withIdentifier: "first", for: indexPath)
            
            let presentationView = firstCell.contentView.subviews[0]
            presentationView.layer.cornerRadius = 5.0
            presentationView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
           
            return detailViewModel.updateHistoryDetail(cell: firstCell, indexPath: indexPath)
            
        case ((detailViewModel.details?.count)! - 1): // last cell
            let lastCell = tableView.dequeueReusableCell(withIdentifier: "last", for: indexPath)
            
            let presentationView = lastCell.contentView.subviews[0]
            presentationView.layer.cornerRadius = 5.0
            presentationView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

            return detailViewModel.updateHistoryDetail(cell: lastCell, indexPath: indexPath)
            
        default: // middle cell
            let middleCell = tableView.dequeueReusableCell(withIdentifier: "center", for: indexPath)
            return detailViewModel.updateHistoryDetail(cell: middleCell, indexPath: indexPath)
        }
    }
}

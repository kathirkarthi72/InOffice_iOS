//
//  DashboardViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit
import TOMSMorphingLabel

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var dashboardCollectionView: UICollectionView!
    
    @IBOutlet var dashBoardViewModel: DashboardViewModel!
    
    var timeSheetWorkedLabel: TOMSMorphingLabel?
    
    var timeSheetBalanceLabel: TOMSMorphingLabel?
    
    var addNewSheet: UIButton?
    
    /// Logout Bar Button
    var logoutBarButton: UIBarButtonItem {
        
        let barButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.done, target: self, action: #selector(logoutBarButtonClickedAction))
        barButton.tintColor = UIColor.black
        
        return barButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [NSNotification.Name.NSManagedObjectContextDidSave,
         UIApplication.willEnterForegroundNotification].forEach { (notificationName) in
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(notificationObserved(_:)),
                                                   name: notificationName,
                                                   object: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dashBoardViewModel.vehicles = VehicleManager.current.fetchVehicles
        
        applicationBecomeActive()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dashBoardViewModel.stopTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Dashboard is become active
    func applicationBecomeActive() {
        
        //   RichNotificationManager.current.clearAllDeliveredNotifications() // Clear all delivered notifications
        
        checkIfLoggedIn()
        
        updateValues()
        
        if TimeSheetManager.current.isGetIn {
            startTimer()
        }
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func updateValues() {
        let fetched = dashBoardViewModel.fetchTodayWorkedHoursInSec()
        
        var totalWorked = fetched.worked
        
        if TimeSheetManager.current.isGetIn {
            
            if let loggedIn = fetched.loggedIn {
                
                let timeInterval = Date().timeIntervalSince(loggedIn)
                totalWorked += Int64(timeInterval)
            }
        }
        dashBoardViewModel.workedHoursInSec = totalWorked
    }
    
    // MARK: - Notification Observer
    @objc func notificationObserved(_ notified: Notification) {
        
        switch notified.name {
        case NSNotification.Name.NSManagedObjectContextDidSave:
            debugPrint("Context Saved")
            
        case UIApplication.willEnterForegroundNotification: // Application entered forground.
            // Get current date and calculate balance working time.
            applicationBecomeActive()
        default:
            break
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Constants.Segues.Dashboard.toTodayHistory {
            let detailVC = segue.destination as! TimeSheetDetailViewController
            
            if TimeSheetManager.current.today != nil {
                detailVC.sheedID = TimeSheetManager.current.today
                detailVC.title = "Today"
                detailVC.fillColor = UIColor.dynamicColor(secs: dashBoardViewModel.workedHoursInSec)
            }
        } else if segue.identifier == Constants.Segues.Dashboard.toMileageHistory {
            let fuelDetailVC = segue.destination as! MileageHistoryViewController
            
            let detail = sender as! [String: String]
            let plateNo = detail["plate"] ?? ""
            let type = detail["type"] ?? ""
            
            fuelDetailVC.plateNumber = plateNo
            
            if type == "Bike" {
                fuelDetailVC.title = "🏍 " + plateNo
            } else {
                fuelDetailVC.title = "🚗 " +  plateNo
            }
        }
    }
    
    // MARK: - Button Action
    
    /// Timesheet shift in and out button was clicked.
    @objc func timeSheetShiftInOutButtonWasClicked(_ sender: Any) {
        
        if TimeSheetManager.current.today == nil {
            TimeSheetManager.current.today = Date().convert(.toDateOnly)
        }
        
        if TimeSheetManager.current.isGetIn { // Logging out
            TimeSheetManager.current.updateShiftOutData(toSheet: TimeSheetManager.current.today!)
            
            dashBoardViewModel.stopTimer()
            
            dashBoardViewModel.scheduleNotifications(isUserLoggedIn: false) // Logged out
            
            UIImpactFeedbackGenerator().impactOccurred() // haptic impact
            
        } else { // Logging In
            TimeSheetManager.current.insertShiftInData()
            startTimer()
            dashBoardViewModel.scheduleNotifications(isUserLoggedIn: true)  // Logged in
            
            UIImpactFeedbackGenerator().impactOccurred() // haptic impact
        }
        
        DispatchQueue.main.async {
            self.dashboardCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
    }
    
    /// Show Today sheet.
    @objc func showTodaySheet(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segues.Dashboard.toTodayHistory, sender: nil)
    }
}

// MARK: - Collectionview delegate
extension DashboardViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath)
            
            if let greetingLabel = headerView.subviews[0] as?  UILabel {
                greetingLabel.text = "Howdy, \(InOfficeManager.current.userInfos?.name ?? "")"
            }
            
            //do other header related calls or settups
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "VehicleInfoFooter", for: indexPath)
            
            //            let addVehicleButton = footerView.subviews[0] as! UIButton
            //            addVehicleButton.addTarget(self, action: #selector(addVehicleButtonClickedAction), for: .touchUpInside)
            //
            //do other header related calls or settups
            return footerView
        default:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + ( dashBoardViewModel.vehicles ??  []).count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            return CGSize(width: self.view.frame.size.width, height: 230.0)
            
        } else {
            return CGSize(width: self.view.frame.size.width, height: 165.0)
        }
        
        /* switch UIDevice.current.orientation {
         case .landscapeLeft, .landscapeRight:
         return CGSize(width: 230.0, height:  self.view.frame.size.width)
         default:
         return CGSize(width: self.view.frame.size.width, height: 230.0)
         }
         */
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let timeSheetCell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeSheetCell", for: indexPath)
            
            let overView = timeSheetCell.contentView.subviews[0]
            overView.layer.cornerRadius = 10
            
            if overView.subviews.count > 0 {
                
                let timeSheetOverView = overView.subviews[1]
                timeSheetOverView.layer.cornerRadius = 10
                
                timeSheetWorkedLabel = timeSheetOverView.subviews[2] as? TOMSMorphingLabel
                timeSheetBalanceLabel = timeSheetOverView.subviews[3] as? TOMSMorphingLabel
                
                addNewSheet = overView.subviews[2] as? UIButton
                
                addNewSheet?.addTarget(self, action: #selector(addNewTimeSheetbuttonTapped), for: .touchUpInside) // Add new timesheet
                
                if let workedLabel = timeSheetWorkedLabel {
                    
                    workedLabel.setText( "Worked: \(dashBoardViewModel.workedHoursInSec.secondsToHoursMinutesSeconds())", withCompletionBlock: nil)
                }
                
                if let balanceLabel = timeSheetBalanceLabel {
                    let balance = dashBoardViewModel.totalProductionHoursInSec - dashBoardViewModel.fetchTodayWorkedHoursInSec().worked
                    
                    balanceLabel.setText( "Balance: \(balance.secondsToHoursMinutesSeconds())", withCompletionBlock: nil)
                }
                
                if let shiftInOutButton = timeSheetOverView.subviews[4] as? UIButton {
                    shiftInOutButton.isSelected = TimeSheetManager.current.isGetIn ? true: false
                    
                    shiftInOutButton.addTarget(self, action: #selector(timeSheetShiftInOutButtonWasClicked(_:)), for: .touchUpInside)
                }
                
                if let detailButton = timeSheetOverView.subviews[5] as? UIButton {
                    detailButton.addTarget(self, action: #selector(showTodaySheet(_:)), for: .touchUpInside)
                }
            }
            
            let shadowPath = UIBezierPath(rect: overView.bounds)
            overView.layer.masksToBounds = true
            overView.layer.shadowColor = UIColor.black.cgColor
            overView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            overView.layer.shadowOpacity = 0.5
            overView.layer.cornerRadius = 10
            overView.layer.shadowPath = shadowPath.cgPath
            
            return timeSheetCell
        } else {
            
            let index = indexPath.row - 1
            let vechile =  dashBoardViewModel.vehicles ?? []
            
            let vehicleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "vehicleInfoCell", for: indexPath)
            
            let overView = vehicleCell.contentView.subviews[0]
            overView.layer.cornerRadius = 10
            
            if overView.subviews.count > 0 {
                
                let timeSheetOverView = overView.subviews[1]
                timeSheetOverView.layer.cornerRadius = 10
                
                let deleteButton = overView.subviews[2] as? UIButton
                deleteButton?.tag = indexPath.row
                deleteButton?.addTarget(self, action: #selector(deleteVechile(_:)), for: .touchUpInside) // Add new timesheet
                
                if let title = overView.subviews[0] as? UILabel, let type = vechile[index].type {
                    if type == "Bike" {
                        title.text = type + " 🏍"
                    } else {
                        title.text = type + " 🚗"
                    }
                }
                
                if let plateNoLabel = timeSheetOverView.subviews[2] as? UILabel {
                    
                    let plateAttributed = NSMutableAttributedString(string: "Plate No: ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)])
                    plateAttributed.append(NSAttributedString(string: "\(vechile[index].plateNo ?? "")", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15.0)]))
                    
                    plateNoLabel.attributedText = plateAttributed
                }
                
                if let totalMileageLabel = timeSheetOverView.subviews[3] as? UILabel {
                    
                    var result = vechile[index].bestMileage
                    
                    if VehicleManager.current.fetchAverageMileage(plateNumber: "\(vechile[index].plateNo ?? "")") > 0.0 {
                        result = VehicleManager.current.fetchAverageMileage(plateNumber: "\(vechile[index].plateNo ?? "")").rounded()
                    }
                    
                    let mileageAttributed = NSMutableAttributedString(string: "Best Mileage: ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)])
                    mileageAttributed.append(NSAttributedString(string: "\(String(result)) km/l", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15.0)]))
                    
                    totalMileageLabel.attributedText = mileageAttributed
                }
            }
            
            let shadowPath = UIBezierPath(rect: overView.bounds)
            overView.layer.masksToBounds = true
            overView.layer.shadowColor = UIColor.black.cgColor
            overView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            overView.layer.shadowOpacity = 0.5
            overView.layer.cornerRadius = 10
            overView.layer.shadowPath = shadowPath.cgPath
            
            return vehicleCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 { // TimeSheet Cell
            UIImpactFeedbackGenerator().impactOccurred() // haptic impact
            
            self.performSegue(withIdentifier: Constants.Segues.Dashboard.toTimesheetHistory, sender: nil)
        } else { // mileage information
            UIImpactFeedbackGenerator().impactOccurred() // haptic impact
            
            let index = indexPath.row - 1
            let vehicle =  dashBoardViewModel.vehicles ?? []
            
            
            
            self.performSegue(withIdentifier: Constants.Segues.Dashboard.toMileageHistory, sender: ["plate": vehicle[index].plateNo ?? "",
                                                                                                    "type": vehicle[index].type ?? ""])
        }
    }
}

//MARK: - Update TimeSheet Timer - Live updater

extension DashboardViewController {
    
    func startTimer() {
        
        dashBoardViewModel.stopTimer()
        
        dashBoardViewModel.timeSheetLiveUpdated = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeSheetLiveUpdater), userInfo: nil, repeats: true)
    }
    
    /// Update timesheet timer
    @objc func timeSheetLiveUpdater() {
        
        dashBoardViewModel.workedHoursInSec += 1
        
        if let workedLabel = timeSheetWorkedLabel {
            
            workedLabel.setText("Worked: \(dashBoardViewModel.workedHoursInSec.secondsToHoursMinutesSeconds())", withCompletionBlock: nil)
            
            //            let worked = NSMutableAttributedString(string: "Worked: ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)])
            //            worked.append(NSAttributedString(string: "\(dashBoardViewModel.workedHoursInSec.secondsToHoursMinutesSeconds())", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15.0)]))
            //
            //            workedLabel.attributedText = worked
        }
        
        if let balanceLabel = timeSheetBalanceLabel {
            let balance = dashBoardViewModel.totalProductionHoursInSec - dashBoardViewModel.workedHoursInSec
            
            balanceLabel.setText("Balance: \(balance.secondsToHoursMinutesSeconds())", withCompletionBlock: nil)
            
            //            let balanced = NSMutableAttributedString(string: "Balance: ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)])
            //            balanced.append(NSAttributedString(string: "\(balance.secondsToHoursMinutesSeconds())", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15.0)]))
            //
            //            balanceLabel.attributedText = balanced
        }
    }
    
    /// Add new timesheet button tapped.
    @objc func addNewTimeSheetbuttonTapped() {
        
        UIImpactFeedbackGenerator().impactOccurred() // haptic impact
        
        if TimeSheetManager.current.isGetIn {
            
            let sheet = UIAlertController(title: "You are in office still now.", message: "Make as to shift out?", preferredStyle: .actionSheet)
            let logoutAction = UIAlertAction(title: "Shift Now", style: .default) { (okAction) in
                
                self.timeSheetShiftInOutButtonWasClicked(self)
                
                self.updateValues()
                DispatchQueue.main.async {
                    self.dashboardCollectionView.reloadData()
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
                
                RichNotificationManager.current.clearPendingNotification(requestIDs: [Constants.Notification.RequestID.logOut, Constants.Notification.RequestID.takeBreak, Constants.Notification.RequestID.comeBackAfterBreak]) // Log out notification removed.
                
                self.updateValues()
                
                DispatchQueue.main.async {
                    self.dashboardCollectionView.reloadData()
                }
                
            }
            sheet.addAction(saveCreateAction)
            
            let createAction = UIAlertAction(title: "Create only", style: .default) { (okAction) in
                TimeSheetManager.current.createNewRecord(withSave: false)
                
                RichNotificationManager.current.clearPendingNotification(requestIDs: [Constants.Notification.RequestID.logOut, Constants.Notification.RequestID.takeBreak, Constants.Notification.RequestID.comeBackAfterBreak]) // Log out notification removed.
                
                self.updateValues()
                
                DispatchQueue.main.async {
                    self.dashboardCollectionView.reloadData()
                }
            }
            sheet.addAction(createAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            sheet.addAction(cancelAction)
            
            self.present(sheet, animated: true, completion: nil)
        }
    }
    
    @objc func deleteVechile(_ sender: Any) {
        
        if let delete = sender as? UIButton {
            let tag = delete.tag
            
            let index = tag - 1
            
            let sheet = UIAlertController(title: "Delete vehicle ?", message: nil, preferredStyle: .actionSheet)
            let shiftoutAction = UIAlertAction(title: "Delete now", style: .default) { (okAction) in
                
                if let vehicles =  self.dashBoardViewModel.vehicles, let plateNo = vehicles[index].plateNo {
                    VehicleManager.current.delete(vehicle: plateNo, deleted: {
                        // self.dashboardCollectionView.deleteItems(at: [IndexPath(item: tag, section: 0)])
                        
                        DispatchQueue.main.async {
                            self.dashboardCollectionView.reloadData()
                        }
                    })
                }
            }
            sheet.addAction(shiftoutAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            sheet.addAction(cancelAction)
            
            self.present(sheet, animated: true, completion: nil)
        }
    }
}

// MARK: - Logout Module
extension DashboardViewController {
    
    /// Check user logged in state and update UI
    fileprivate func checkIfLoggedIn() {
        
        if InOfficeManager.current.isUserLoggedIn {
            
            RichNotificationManager.current.registerUserNotification()
            
            DispatchQueue.main.async {
                self.dashboardCollectionView.reloadData()
            }
        } else {
            self.performSegue(withIdentifier: Constants.Segues.Dashboard.toInitialVC, sender: nil)
        }
    }
    
    // MARK: - BarButton Action
    func showLogoutBarButton() {
        self.navigationItem.leftBarButtonItem = logoutBarButton
        
    }
    
    // MARK: - Shaked
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.type == UIEvent.EventType.motion {
            // iPhone shaked
            showLogoutBarButton()
        }
        super.motionEnded(motion, with: event)
    }
    
    // MARK: - Button Action
    @objc func logoutBarButtonClickedAction() {
        UIImpactFeedbackGenerator().impactOccurred() // haptic impact
        
        if TimeSheetManager.current.isGetIn {
            
            let sheet = UIAlertController(title: "You are still in office", message: "Make as to shift out?", preferredStyle: .actionSheet)
            let shiftoutAction = UIAlertAction(title: "Shift out now", style: .default) { (okAction) in
                
                if TimeSheetManager.current.today == nil {
                    TimeSheetManager.current.today = Date().convert(.toDateOnly)
                }
                
                if let sheedID = TimeSheetManager.current.today, !sheedID.isEmpty {
                    self.timeSheetShiftInOutButtonWasClicked(self)
                    
                    DispatchQueue.main.async {
                        self.dashboardCollectionView.reloadData()
                    }
                }
            }
            sheet.addAction(shiftoutAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            sheet.addAction(cancelAction)
            
            self.present(sheet, animated: true, completion: nil)
        } else {
            let sheet = UIAlertController(title: "Logout", message: "Clear all records and reset user details", preferredStyle: .actionSheet)
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (okAction) in
                
                if InOfficeManager.current.userLoggedOut() {
                    self.checkIfLoggedIn()
                }
            }
            sheet.addAction(confirmAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            sheet.addAction(cancelAction)
            
            self.present(sheet, animated: true, completion: nil)
        }
    }
}

extension UIAlertController{
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.tintColor = .black
    }
}

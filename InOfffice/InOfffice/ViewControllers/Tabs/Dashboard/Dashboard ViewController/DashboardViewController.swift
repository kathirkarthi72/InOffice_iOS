//
//  DashboardViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var dashboardCollectionView: UICollectionView!
    
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    
    @IBOutlet var dashBoardViewModel: DashboardViewModel!
    
    var timeSheetWorkedLabel: UILabel?
    
    var timeSheetBalanceLabel: UILabel?
    
    /// Logout Bar Button
    var logoutBarButton: UIBarButtonItem {
        
        let barButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.done, target: self, action: #selector(logoutBarButtonClickedAction))
        barButton.tintColor = UIColor.theme
        
        return barButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [NSNotification.Name.NSManagedObjectContextDidSave,
         NSNotification.Name.UIApplicationWillEnterForeground].forEach { (notificationName) in
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(notificationObserved(_:)),
                                                   name: notificationName,
                                                   object: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       applicationBecomeActive()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        case NSNotification.Name.UIApplicationWillEnterForeground: // Application entered forground.
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
        
        if segue.identifier == "toTodayHistory" {
            let detailVC = segue.destination as! TimeSheetDetailViewController
            detailVC.cameBy = .dashBoard
            
            if TimeSheetManager.current.today != nil {
                detailVC.sheedID = TimeSheetManager.current.today
                detailVC.title = "Today"
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

        } else { // Logging In
            TimeSheetManager.current.insertShiftInData()
            startTimer()
            
            dashBoardViewModel.scheduleNotifications(isUserLoggedIn: true)  // Logged in
        }
        
        DispatchQueue.main.async {
            self.dashboardCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
    }
    
    /// Show Today sheet.
    @IBAction func showTodaySheet(_ sender: Any) {
        let longPressGesture = sender as! UILongPressGestureRecognizer
        
        if longPressGesture.state == .began {
            debugPrint("Show Today sheet")
            
            self.performSegue(withIdentifier: "toTodayHistory", sender: nil)
        }
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
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath)
            
            if let greetingLabel = headerView.subviews[0] as?  UILabel {
                greetingLabel.text = "Howdy, \(InOfficeManager.current.userInfos?.name ?? "")"
            }
            
            //do other header related calls or settups
            return headerView
            
        default:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            return CGSize(width: 350, height: 140.0)
        default:
            return CGSize(width: self.view.frame.size.width, height: 140.0)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let timeSheetCell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeSheetCell", for: indexPath)
        
        let overView = timeSheetCell.contentView.subviews[0]
        overView.layer.cornerRadius = 10
        
        if overView.subviews.count > 0 {
            
            let timeSheetOverView = overView.subviews[1]
            timeSheetOverView.layer.cornerRadius = 10
            
            timeSheetWorkedLabel = timeSheetOverView.subviews[2] as? UILabel
            timeSheetBalanceLabel = timeSheetOverView.subviews[3] as? UILabel
            
            if let workedLabel = timeSheetWorkedLabel {
                workedLabel.text = "Worked: \(dashBoardViewModel.workedHoursInSec.secondsToHoursMinutesSeconds())"
            }
            
            if let balanceLabel = timeSheetBalanceLabel {
                let balance = dashBoardViewModel.totalProductionHoursInSec - dashBoardViewModel.fetchTodayWorkedHoursInSec().worked
                balanceLabel.text = "Balance: \(balance.secondsToHoursMinutesSeconds())"
            }
            
            if let shiftInOutButton = timeSheetOverView.subviews[4] as? UIButton {
                
                if TimeSheetManager.current.isGetIn {
                    shiftInOutButton.isSelected = true
                } else {
                    shiftInOutButton.isSelected = false
                }
                
                shiftInOutButton.addTarget(self, action: #selector(timeSheetShiftInOutButtonWasClicked(_:)), for: .touchUpInside)
            }
        }
        
        overView.addGestureRecognizer(longPressGesture)
        
        return timeSheetCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 { // TimeSheet Cell
            self.performSegue(withIdentifier: Constants.Segues.Dashboard.toTimesheetHistory, sender: nil)
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
        
        debugPrint("\(dashBoardViewModel.workedHoursInSec)")
        
        if let workedLabel = timeSheetWorkedLabel {
            workedLabel.text = "Worked: \(dashBoardViewModel.workedHoursInSec.secondsToHoursMinutesSeconds())"
        }
        
        
        if let balanceLabel = timeSheetBalanceLabel {
            let balance = dashBoardViewModel.totalProductionHoursInSec - dashBoardViewModel.workedHoursInSec
            balanceLabel.text = "Balance: \(balance.secondsToHoursMinutesSeconds())"
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
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.type == UIEventType.motion {
            // iPhone shaked
            showLogoutBarButton()
        }
        super.motionEnded(motion, with: event)
    }
    
    // MARK: - Button Action
    @objc func logoutBarButtonClickedAction() {
        
        if TimeSheetManager.current.isGetIn {
            
            let sheet = UIAlertController(title: "You are still in office",
                                          message: "Make as to shift out?",
                                          preferredStyle: .actionSheet)
            
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

//
//  OrderNumberGameViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class OrderNumberGameViewController: UIViewController {
    
    @IBOutlet var playGroundViewModel: OrderNumberGameViewModel!
    @IBOutlet weak var numbersCollectionView: UICollectionView!
    @IBOutlet weak var countDownLabel: UIBarButtonItem!
    
    private var levelDetail: LevelDetail?
    
    var countDownTimer: Timer?

    fileprivate func createNewLevel() {
        
        if levelDetail == nil {
            /// Show New Screen
        }
        
        levelDetail = playGroundViewModel.newGame()
        
        levelDetail?.estimateSeconds += playGroundViewModel.savedSeconds
        
        setupLevel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        numbersCollectionView.dragDelegate = self
        numbersCollectionView.dropDelegate = self
        numbersCollectionView.dragInteractionEnabled = true
        numbersCollectionView.allowsMultipleSelection = false
        
        createNewLevel()
        
        [UIApplication.didEnterBackgroundNotification,
         UIApplication.willEnterForegroundNotification,
         UIApplication.willTerminateNotification].forEach { (notificationName) in
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(notificationCenterObservered(notification:)),
                                                   name: notificationName,
                                                   object: nil)
        }
    }
    
    /*
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      //  self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
      //  self.navigationController?.isNavigationBarHidden = false
    }
     
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLevel() {
        
        if let level = levelDetail {
            
            DispatchQueue.main.async {
                self.countDownLabel.title = String(describing: level.estimateSeconds)
                
                self.title = "Level \(self.playGroundViewModel.completedLevels)"
                self.numbersCollectionView.reloadData()
            }
        }
        
        startTimer()
    }
    
    // MARK: Notification received.
    @objc func notificationCenterObservered(notification: Notification) {
        
        if self.tabBarController?.selectedIndex == 2 {
            switch notification.name {
            case UIApplication.didEnterBackgroundNotification, UIApplication.willTerminateNotification:
                gamePaused()
            case UIApplication.willEnterForegroundNotification:
                gameResumed()
            default:
                break
            }
        }
    }
    
    // MARK: Timer handling
    
    func startTimer() {
        
        stopTimer()
        
        countDownTimer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(timerFired),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    @objc func timerFired() {
        
        if let level = levelDetail {
            self.levelDetail?.completedSeconds += 1
            
            let deviation = level.estimateSeconds - level.completedSeconds
            
            if deviation <= 0 {
                levelFailed()
            } else {
                DispatchQueue.main.async {
                    self.countDownLabel.title = String(describing: deviation)
                }
            }
        }
    }
    
    func stopTimer() {
        if let timer = countDownTimer, timer.isValid {
            countDownTimer?.invalidate()
            countDownTimer = nil
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: BarButton Action
    
    @IBAction func newGameBarButtonClickedAction(_ sender: Any) {
        createNewLevel()
    }
    
    //MARK: Level handling
    
    /// Check level compelted
    func checkLevelCompelted() {
        
        if let levelDetails = levelDetail {
            
            if playGroundViewModel.isLevelCompleted(levelDetails: levelDetails) {
                self.stopTimer()
                
                let alert = UIAlertController(title: "Level Up!", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default) { (action) in
                    
                    let deviation = levelDetails.estimateSeconds - levelDetails.completedSeconds
                    
                    if self.playGroundViewModel.levelUp(savedSeconds: deviation) {
                        self.createNewLevel()
                    }
                }
                
                alert.addAction(action)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func levelFailed() {
        
        stopTimer()
        
        let alert = UIAlertController(title: "Time Out!", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.createNewLevel()
        }
        
        alert.addAction(action)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func gamePaused() {
        stopTimer()
    }
    
    func gameResumed() {
        startTimer()
    }
    
}

extension OrderNumberGameViewController {
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: CollectionView delegates
extension OrderNumberGameViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (levelDetail?.unOrdered.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            return CGSize(width: self.view.bounds.size.height/5, height: self.view.bounds.size.height/5)
        default:
            return CGSize(width: self.view.bounds.size.width/5, height: self.view.bounds.size.width/5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath)
        let title = cell.contentView.subviews[0] as! UILabel
        
        if let levelDetail = levelDetail {
            title.text = "\(String(describing: levelDetail.unOrdered[indexPath.item]))"
            
           /* if levelDetail.ordered[indexPath.item] == levelDetail.unOrdered[indexPath.item] {
                title.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
            } else {
                title.backgroundColor = UIColor.white
            }
            */
            
            title.layer.cornerRadius = 2.0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /*
     func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
     
     if let levelDetails = levelDetail {
     levelDetail?.unOrdered = rearrange(array: levelDetails.unOrdered, fromIndex: sourceIndexPath.item, toIndex: destinationIndexPath.item)
     
     checkLevelCompelted()
     }
     }
     */
}

extension OrderNumberGameViewController : UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    // Single item drag
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        if let level = levelDetail {
            let item = level.unOrdered[indexPath.row]
            let itemProvider = NSItemProvider(object: "\(item)" as NSItemProviderWriting)
            
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            return [dragItem]
        }
        
        return []
    }
    
    // Multiple items drag
  func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        if let level = levelDetail {
            let item = level.unOrdered[indexPath.row]
            let itemProvider = NSItemProvider(object: "\(item)" as NSItemProviderWriting)
            
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            return [dragItem]
        }
        return []
    }
  
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        
        /* if session.localDragSession != nil {
         if collectionView.hasActiveDrag {
         return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
         } else {
         return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
         }
         } else {
         return UICollectionViewDropProposal(operation: .forbidden)
         }
         */
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) { // Droping performance
        
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of collection view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation {
        case .move:
            //Add the code to reorder items
            
            /* collectionView.performBatchUpdates({
             var indexPaths = [IndexPath]()
             for (index, item) in coordinator.items.enumerated() {
             //Destination index path for each item is calculated separately using the destinationIndexPath fetched from the coordinator
             let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
             
             if levelDetail != nil {
             self.levelDetail?.unOrdered.insert(item.dragItem.localObject as! Int, at: indexPath.row)
             }
             indexPaths.append(indexPath)
             }
             collectionView.insertItems(at: indexPaths)
             })
             */
            
            let items = coordinator.items
            if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath {
                var dIndexPath = destinationIndexPath
                if dIndexPath.row >= collectionView.numberOfItems(inSection: 0) {
                    dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
                }
                
                collectionView.performBatchUpdates({
                    
                    if levelDetail != nil {
                        self.levelDetail?.unOrdered.remove(at: sourceIndexPath.row)
                        self.levelDetail?.unOrdered.insert(item.dragItem.localObject as! Int, at: dIndexPath.row)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [dIndexPath])
                    }
                    
                })
                coordinator.drop(item.dragItem, toItemAt: dIndexPath)
            }
            
            checkLevelCompelted()
        case .copy:
            //Add the code to copy items
            //  break
            return
        default:
            return
        }
    }
}

extension OrderNumberGameViewController : UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if tabBarController.selectedIndex == 2 {
            self.gameResumed()
        } else { // Other VC
            self.gamePaused()
        }
    }
}

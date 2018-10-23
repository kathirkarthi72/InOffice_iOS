//
//  HealthViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit
import CoreMotion

class HealthViewController: UIViewController, UICollisionBehaviorDelegate {
    
    @IBOutlet var healthViewModel: HealthViewModel!
    
    @IBOutlet weak var boundaryView: UIView!
    let manager = CMMotionManager()
    
    var isAccelerometerAvailable: Bool {
        guard manager.isAccelerometerAvailable else {
            return false
        }
        return true
    }
    
    var animator : UIDynamicAnimator!
    
    var gravityBehaviour: UIGravityBehavior!
    
    var watterButton: [RoundedBall] {
        var watterButton: [RoundedBall] = []
        
        boundaryView.subviews.forEach({
            watterButton.append($0 as! RoundedBall) })
        
        return watterButton
    }
    
    /// Add Gravity aniamtion
    func addGravityAnimator()  {
        
        self.animator = UIDynamicAnimator(referenceView: self.boundaryView)
        let direction = CGVector(dx: 0.0, dy: 0.2)
        
        gravityBehaviour = UIGravityBehavior(items: watterButton)
        gravityBehaviour.gravityDirection = direction
        animator.addBehavior(gravityBehaviour)
        
        let collusionBehaviour = UICollisionBehavior(items: watterButton)
        collusionBehaviour.collisionDelegate = self
        
        /*     collusionBehaviour.addBoundary(withIdentifier: "navigationbar" as NSCopying,
         from: CGPoint(x: 0, y: 0),
         to: CGPoint(x: ((self.navigationController?.navigationBar.frame.origin.x)! + (self.navigationController?.navigationBar.frame.size.width)!),
         y: (self.navigationController?.navigationBar.frame.size.height)!))
         
         collusionBehaviour.addBoundary(withIdentifier: "tabbar" as NSCopying,
         from: (self.tabBarController?.tabBar.frame.origin)!,
         to: CGPoint(x: ((self.tabBarController?.tabBar.frame.origin.x)! + (self.tabBarController?.tabBar.frame.size.width)!),
         y: (self.tabBarController?.tabBar.frame.origin.y)!))
         */
        
        collusionBehaviour.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collusionBehaviour)
        
        let buttonBehaviour = UIDynamicItemBehavior(items: watterButton)
        buttonBehaviour.elasticity = 0.5
        buttonBehaviour.resistance = 0.5
        buttonBehaviour.friction = 0.5
        buttonBehaviour.allowsRotation = false
        buttonBehaviour.density = 50.0;
        self.animator.addBehavior(buttonBehaviour)
        
        let pushBehaviour = UIPushBehavior.init(items: watterButton, mode: UIPushBehaviorMode.instantaneous)
        pushBehaviour.magnitude = 1.0
        animator.addBehavior(pushBehaviour)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        watterButton.forEach({
            $0.layer.cornerRadius = $0.frame.size.width / 2
            $0.layer.masksToBounds = true
        })
        
        healthViewModel.requestAuthorization()
        
        addGravityAnimator()
        
        manager.startAccelerometerUpdates(to: .main) { (data, error) in
            
            guard let accelerometerData = data else {
                print(error?.localizedDescription ?? "Error while update device gravity")
                return
            }
            
            // physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
            let direction = CGVector(dx: accelerometerData.acceleration.x, dy: accelerometerData.acceleration.y)
            self.gravityBehaviour.gravityDirection = direction
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     override func viewDidAppear(_ animated: Bool) {
     super.viewDidAppear(animated)
     }
     */
    
    // MARK: Button action
    @IBAction func inTakeWaterButtonClicked(_ sender: Any) {
        
        if let button = sender as? RoundedBall {
            
            switch button.tag {
            case 100:
                healthViewModel.addWaterInTake(onces: 0.100) // 100 ml drunk
            case 200:
                healthViewModel.addWaterInTake(onces: 0.200) // 100 ml drunk
            case 300:
                healthViewModel.addWaterInTake(onces: 0.300) // 100 ml drunk
            case 400:
                healthViewModel.addWaterInTake(onces: 0.400) // 100 ml drunk
            case 500:
                healthViewModel.addWaterInTake(onces: 0.500) // 100 ml drunk
            default:
                break
            }
            
            button.isSelected = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                button.isSelected = false
            }
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
    
    /*
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     if let touch = touches.first, let touchedView = touch.view, self.view.subviews.contains(touchedView) {
     if let label = watterButton.filter({ $0.tag == touchedView.tag }).first {
     label.center = touch.location(in: self.view)
     }
     }
     super.touchesBegan(touches, with: event)
     }
     
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     if let touch = touches.first, let touchedView = touch.view, self.view.subviews.contains(touchedView) {
     if let label = watterButton.filter({ $0.tag == touchedView.tag }).first {
     label.center = touch.location(in: self.view)
     }
     }
     super.touchesMoved(touches, with: event)
     }
     
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     if let touch = touches.first, let touchedView = touch.view, self.view.subviews.contains(touchedView) {
     if let label = watterButton.filter({ $0.tag == touchedView.tag }).first {
     label.center = touch.location(in: self.view)
     }
     }
     
     super.touchesEnded(touches, with: event)
     }
     
     override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
     if let touch = touches.first, let touchedView = touch.view, self.view.subviews.contains(touchedView) {
     if let label = watterButton.filter({ $0.tag == touchedView.tag }).first {
     label.center = touch.location(in: self.view)
     }
     
     }
     super.touchesCancelled(touches, with: event)
     }
     */
}


class RoundedBall: UIButton {
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
    
}

//
//  ViewExtension.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /// Add Shadow
    public func addShadow() {
        let shadowPath = UIBezierPath(rect: self.bounds)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowPath = shadowPath.cgPath
    }
}

extension UIViewController {
    
    /// Get notification settings
    public func getNotificationAccess() {
        let getNotificationPermission = UIAlertController(title: "Allow notification to notify your logout time", message: "Go to settings and change permission", preferredStyle: .alert)
        
        let settings = UIAlertAction(title: "Settings", style: .default, handler: { (action) in
            UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!)! as URL, options: [:], completionHandler: nil)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            //Do nothing.
        })
        
        getNotificationPermission.addAction(settings)
        getNotificationPermission.addAction(cancel)
        
        present(getNotificationPermission, animated: true, completion: nil)
    }
}

extension UIApplication {
    
    /// Current Visible viewController
    var visibleViewController : UIViewController? {
        
        if UIApplication.shared.keyWindow?.rootViewController is UINavigationController {
            return (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).visibleViewController
        }
        return nil
    }
}

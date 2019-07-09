//
//  UIColorExtension.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// Theme color
    public static let theme = UIColor(red: 36.0/255.0, green: 128.0/255.0, blue: 106.0/255.0, alpha: 1.0)
    
    /// Worked color
    public static let worked = UIColor(red: 8.0/255.0, green: 117.0/255.0, blue: 98.0/255.0, alpha: 1.0)
    
    /// Dynamic color
    ///
    /// - Parameter secs: worked hours in seconds
    /// - Returns: color
    public static func dynamicColor(secs: Int64) -> UIColor {
        
        switch secs {
            
        case 0...1*60*60: // 1 hours
            return UIColor.lightGray.withAlphaComponent(0.4)
            
        case 1*60*60...2*60*60: // 2 hours
            return UIColor.purple.withAlphaComponent(0.4)
            
        case 2*60*60...3*60*60: // 3 hours
            return UIColor.brown.withAlphaComponent(0.4)
            
        case 3*60*60...4*60*60: // 4 hours
            return UIColor.yellow.withAlphaComponent(0.6)
            
        case 4*60*60...5*60*60: // 5 hours
            return UIColor.blue.withAlphaComponent(0.4)
            
        case 5*60*60...6*60*60: // 6 hours
            return UIColor.green.withAlphaComponent(0.4)
            
        case 6*60*60...7*60*60: // 6 hours
            return UIColor.cyan.withAlphaComponent(0.4)
            
        case 7*60*60...8*60*60: // 8 hours
                return UIColor.orange.withAlphaComponent(0.4)

        case 8*60*60...9*60*60: // 9 hours
            return UIColor.theme.withAlphaComponent(0.4)

        default:
            return UIColor.red.withAlphaComponent(0.4)
        }
    }
}
//
//@available(swift, deprecated: 12.4, message: "This colors are available in iOS13")
//extension UIColor {
//    
//    public static let label = UIColor.white
//    
//    public static let link = UIColor.black
//
//}

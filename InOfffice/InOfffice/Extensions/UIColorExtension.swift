//
//  UIColorExtension.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

extension UIColor {
    public static let theme = UIColor(red: 36.0/255.0, green: 128.0/255.0, blue: 106.0/255.0, alpha: 1.0)
    
    public static let worked = UIColor(red: 8.0/255.0, green: 117.0/255.0, blue: 98.0/255.0, alpha: 1.0)
    
    public static func dynamicColor(secs: Int64) -> UIColor {
        switch secs {
        case 0...3600: // 1 hours
            return UIColor.lightGray.withAlphaComponent(0.4)
            
        case 3600...10800: // 3 hours
            return UIColor.brown.withAlphaComponent(0.4)
            
        case 10800...14400: // 4 hours
            return UIColor.yellow.withAlphaComponent(0.4)
            
        case 14400...25200: // 7 hours
            return UIColor.green.withAlphaComponent(0.4)
            
        case 25200...28800: // 8 hours
            return UIColor.theme.withAlphaComponent(0.4)
            
        case 28800...32400: // 9 hours
            return UIColor.orange.withAlphaComponent(0.4)
            
        default:
            return UIColor.red.withAlphaComponent(0.4)
        }
    }
}

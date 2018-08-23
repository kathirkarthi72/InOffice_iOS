//
//  RichNotificationManager.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class RichNotificationManager: NSObject {

    static let current: RichNotificationManager = {
      
        let instance = RichNotificationManager()
        return instance
    }()

}

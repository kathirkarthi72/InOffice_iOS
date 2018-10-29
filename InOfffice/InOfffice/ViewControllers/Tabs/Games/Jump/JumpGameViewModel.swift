//
//  JumpGameViewModel.swift
//  InOfffice
//
//  Created by ktrkathir on 11/10/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class JumpGameViewModel: NSObject {

    var score: Int64 = 0
    
    let maxJumpHeight: Int = 300 // ft
    
    let requiredAccelerationScaleFactor = 85.0 // Heiger means your need less force to reach a height
    
    let minimumJumAccelerationHeight = 10.0
    
    var selectedHeight = 140.0 // ft
}

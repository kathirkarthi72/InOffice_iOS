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
    
   // let maxJumpHeight: Int = 300 // ft
   // let minimumJumpAccelerationHeight = 10.0

    let requiredJumpAccelerationScaleFactor = 85.0
    
   // let requiredSitAccelerationScaleFactor = 85.0 // Heiger means your need less force to reach a height
    
    var selectedHeight = 100.0 // ft
   // var selectedSitHeight = 60.0 // ft

}

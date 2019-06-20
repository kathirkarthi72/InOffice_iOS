//
//  OrderNumberGameViewModel.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

struct LevelDetail {
    var estimateSeconds : Int
    var completedSeconds : Int
    var unOrdered: [Int]
    var ordered : [Int]
}

class OrderNumberGameViewModel: NSObject {
    
    var savedSeconds : Int {
        if let userDetails = InOfficeManager.current.userInfos {
            return userDetails.games.orderNumbers.savedSeconds
        }
        return 0
    }
    
    var completedLevels : Int {
        if let userDetails = InOfficeManager.current.userInfos {
            return userDetails.games.orderNumbers.completedLevels
        }
        return 0
    }
    
    //   private var unOrderedNumber: [Int]?
    
    //  private var orderedNumber: [Int]?
    
    func newGame() -> LevelDetail {
        
        var levelCompleteLimit: Int
        
        switch completedLevels {
        case 0...5:
            levelCompleteLimit = 100 + (completedLevels * 20)
        case 6...10:
            levelCompleteLimit = 150 + (completedLevels * 40)
        case 11...13:
            levelCompleteLimit = 150 + (completedLevels * 50)
        case 14...20:
            levelCompleteLimit = 200 + (completedLevels * 60)
        case 21...25:
            levelCompleteLimit = 300 + (completedLevels * 70)
        case 26...29:
            levelCompleteLimit = 400 + (completedLevels * 80)
        case 30...35:
            levelCompleteLimit = 450 + (completedLevels * 90)
        case 36...45:
            levelCompleteLimit = 500 + (completedLevels * 100)
        case 46...50:
            levelCompleteLimit = 510 + (completedLevels * 110)
        default:
            levelCompleteLimit = 550 + (completedLevels * 120)
        }
        
        
        let limit = ((completedLevels == 0 ? 1 : completedLevels) * 12)
        
        let orderedNumber = Array(1...limit)
        let unOrderedNumber = orderedNumber.shuffled()
        
        return LevelDetail(estimateSeconds: levelCompleteLimit,
                           completedSeconds: 0,
                           unOrdered: unOrderedNumber,
                           ordered: orderedNumber)
    }
    
    func levelUp(savedSeconds: Int) -> Bool {
        
        if var userDetails = InOfficeManager.current.userInfos {
            userDetails.games.orderNumbers.savedSeconds += savedSeconds
            userDetails.games.orderNumbers.completedLevels += 1
            
            return InOfficeManager.current.saved(detail: userDetails)
        }
        
        return false
    }
    
    func isLevelCompleted(levelDetails: LevelDetail) -> Bool {
        
        if levelDetails.unOrdered == levelDetails.ordered {
            return true
        }
        return false
    }
}


extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}



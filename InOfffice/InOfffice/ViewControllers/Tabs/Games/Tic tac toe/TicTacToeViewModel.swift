//
//  TicTacToeViewModel.swift
//  InOfffice
//
//  Created by ktrkathir on 03/10/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

/// Placed Object
///
/// - computer: computer
/// - player: player
enum Placed: String {
    case none = " "
    case computer = "X"
    case player = "O"
}

class TicTacToeViewModel: NSObject {
    
    /// Game state
    ///
    /// - play: continue to play
    /// - draw: match draw
    /// - wonByComputer: Computer win the game
    /// - wonByPlayer: player win the game
    enum GameState {
        case play
        case draw
        case wonByComputer
        case wonByPlayer
    }
    
    
    /// Next move
    ///
    /// - computer: computer turn
    /// - player: player turn
    enum Turn {
        case computer
        case player
    }
    
    var source: [Placed] = Array(repeatElement(Placed.none, count: 9))
    
    var turn: Turn = .player
    
    func newGame() {
        source = Array(repeatElement(Placed.none, count: 9))
      
        print(source)
    }
   
    /// Result of the game
    func result() ->GameState {
        
        let indexes = source.placedIndex
        
        if indexes.computer.isValid {
            return GameState.wonByComputer
        } else if indexes.player.isValid {
            return GameState.wonByPlayer
        } else if indexes.empty.count > 0 {
            return GameState.play
        } else {
            return GameState.draw
        }
    }
    
    
    /// Best move
    func bestMove() -> Int {
        
        let indexes = source.placedIndex
        
        if indexes.player.count == 0 {
            return indexes.empty.randomElement() ?? 0
        } else if indexes.player.count  == 1 {
            if let first = indexes.player.first {
                switch first {
                case 0:
                    return [1,2,3,4,6].randomElement() ?? 1
                case 1:
                    return [0,2,4,7].randomElement() ?? 0
                case 2:
                    return [0,1,4,5,6,8].randomElement() ?? 0
                case 3:
                    return [0,4,5,6].randomElement() ?? 0
                case 4:
                    return indexes.empty.randomElement() ?? 0
                case 5:
                    return [2,3,4,8].randomElement() ?? 2
                case 6:
                    return [0,3,4,2,7,8].randomElement() ?? 0
                case 7:
                    return [1,4,6,8].randomElement() ?? 1
                default:  // 8
                    return [0,2,4,5,6,7].randomElement() ?? 1
                }
            }
            return 0
        } else if indexes.player.count == 2 {
            
            if let first = indexes.player.first, let last = indexes.player.last {
          
            }
            
            return 0
        }
        
        return indexes.empty.first ?? 0
    }
 

}

extension Array where Element == Placed {
    
    /// Placed Indexes
    /// return empty object index, computer placed index, player placed index
    var placedIndex: (empty: [Int], computer: [Int], player: [Int]) {
        let empty = self.indexes(of: .none)
        let computer = self.indexes(of: .computer)
        let player = self.indexes(of: .player)
        
        return (empty, computer, player)
    }
}

extension Array where Element == Int {
    
    var isValid: Bool {
        if self.contains(0), self.contains(1), self.contains(2) ||
            self.contains(3), self.contains(4), self.contains(5) ||
            self.contains(6), self.contains(7), self.contains(8) ||
            self.contains(0), self.contains(3), self.contains(6) ||
            self.contains(1), self.contains(4), self.contains(7) ||
            self.contains(2), self.contains(5), self.contains(8) ||
            self.contains(0), self.contains(4), self.contains(8) ||
            self.contains(2), self.contains(4), self.contains(6) {
          
            return true
        }
        
        return false
    }
    
}

extension Array where Element: Equatable {
    
    /// Indexes of elements
    ///
    /// - Parameter element: search Element
    /// - Returns: indexes
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
    
}

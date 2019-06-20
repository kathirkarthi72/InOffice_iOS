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

/// Next move
///
/// - computer: computer turn
/// - player: player turn
enum Turn {
    case computer
    case player
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
   
    var source: [Placed] = Array(repeatElement(Placed.none, count: 9))
    
    var turn: Turn = .player
    
    var lastWon: Turn = .player
    
    func newGame() {
        source = Array(repeatElement(Placed.none, count: 9))
    }
    
    /// Result of the game
    func result() ->GameState {
        
        let indexes = source.placedIndex
        
        if indexes.computer.isValid() {
            newGame()

            return GameState.wonByComputer
        } else if indexes.player.isValid() {
            newGame()

            return GameState.wonByPlayer

        } else if indexes.empty.count > 0 {
            return GameState.play
        } else {
            newGame()
            return GameState.draw
        }
    }
    
    /// Insert new index
    ///
    /// - Parameter at: position
    func insert(at: Int, doneBy: Placed) {
        
        if source[at] == .none {
           source[at] = doneBy
        }
    }
    
    /// Best move
    ///
    /// - Returns: best posibile index
    func bestMove() -> Int {
        
        let indexes = source.placedIndex
        
        if indexes.player.count == 0 {
            return indexes.empty.randomElement() ?? 0
        } else if indexes.player.count  == 1 {
            
            if let first = indexes.player.first {
                switch first {
                case 0:
                    return [1,2,3,4,6,8].randomElement() ?? 1
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
                    return [0,2,3,4,7,8].randomElement() ?? 0
                case 7:
                    return [1,4,6,8].randomElement() ?? 1
                default:  // 8
                    return [0,2,4,5,6,7].randomElement() ?? 8
                }
            }
            return indexes.empty.randomElement() ?? 0
        } else  {
            
            let computerPosibileIndex = getPosibilities(playiedIndexies: indexes.computer, emptyIndexies: indexes.empty)
            
            var temp = indexes.computer
            temp.append(computerPosibileIndex)
            
            if temp.isValid() {
                return computerPosibileIndex
            } else {
                return getPosibilities(playiedIndexies: indexes.player, emptyIndexies: indexes.empty) // Get posibilities
            }
        }
    }
    
    // variadic function
    func isPosibleIndex(_ index: Int, places: [Int]..., empties: [Int], placedIndex: [Int]) -> Bool {
        
        var posibile: Bool = false
        
        if empties.contains(index) {
            
            for item in 0..<places.count {
                let place = places[item]
                
                if let first = place.first, let last = place.last {
                    if placedIndex.contains(first), placedIndex.contains(last) {
                        posibile = true
                        break
                    } else {
                        posibile = false
                    }
                }
            }
        }
        return posibile
    }
    
    /// get Posibile index
    ///
    /// - Parameters:
    ///   - placedIndex: already placed index
    ///   - empties: empty indexes
    /// - Returns: posibile index
    public func getPosibilities(playiedIndexies: [Int], emptyIndexies: [Int]) -> Int {
        
        if isPosibleIndex(0, places: [1,2], [4,8], [3,6], empties: emptyIndexies, placedIndex: playiedIndexies) {
            return 0
        } else if isPosibleIndex(1, places: [0,2], [4,7], empties: emptyIndexies, placedIndex: playiedIndexies) {
            return 1
        } else if isPosibleIndex(2, places: [0,1],[4,6],[5,8], empties: emptyIndexies, placedIndex: playiedIndexies) {
            return 2
        } else if isPosibleIndex(3, places: [0,6],[4,5], empties: emptyIndexies, placedIndex: playiedIndexies) {
            return 3
        } else if isPosibleIndex(4, places: [0,8],[1,7],[2,6],[3,5], empties: emptyIndexies, placedIndex: playiedIndexies) {
            return 4
        } else if isPosibleIndex(5, places: [2,8],[4,3], empties: emptyIndexies, placedIndex: playiedIndexies) {
            return 5
        } else if isPosibleIndex(6, places: [3,0],[2,4],[7,8], empties: emptyIndexies, placedIndex: playiedIndexies) {
            return 6
        } else if isPosibleIndex(7, places: [1,4],[6,8], empties: emptyIndexies, placedIndex: playiedIndexies) {
            return 7
        } else if isPosibleIndex(8, places: [0,4],[2,5],[6,7], empties: emptyIndexies, placedIndex: playiedIndexies) {
            return 8
        } else {
            return emptyIndexies.randomElement() ?? 8
        }
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
    
    func isValid() -> Bool {
        
        let places: [Int] = self
        
        func verify(first: Int, second: Int, last: Int) -> Bool {
            
            if places.contains(first), places.contains(second), places.contains(last) {
                return true
            }
            return false
        }
        
        if verify(first: 0, second: 1, last: 2) || verify(first: 3, second: 4, last: 5) || verify(first: 6, second: 7, last: 8) || verify(first: 0, second: 3, last: 6) || verify(first: 1, second: 4, last: 7) || verify(first: 2, second: 5, last: 8) || verify(first: 0, second: 4, last: 8) || verify(first: 2, second: 4, last: 6) {
            return  true
        } else {
            return false
        }
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

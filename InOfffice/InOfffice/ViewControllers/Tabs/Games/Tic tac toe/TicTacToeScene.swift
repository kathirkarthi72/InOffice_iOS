//
//  TicTacToePlayground.swift
//  InOfffice
//
//  Created by ktrkathir on 03/10/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import SpriteKit

class TicTacToeScene: SKScene {
    
    var viewModel = TicTacToeViewModel()
    
    var computer: Int = 0
    var player: Int = 0
    
    /// Play tiles nodes
    var playTilesNodes: [SKSpriteNode]? {
        
        if let bgNode = childNode(withName: "playTileBG") as? SKSpriteNode {
            var  nodes: [SKSpriteNode] = []
            bgNode.children.forEach({ nodes.append($0 as! SKSpriteNode) })
            
            return nodes
        }
        return nil
    }
    
    /// Reset button Node
    var resetNode: SKLabelNode? {
        if let reset = childNode(withName: "Reset") as? SKLabelNode {
            return reset
        }
        return nil
    }
    
    /// Player score node
    var playerScoreNode: SKLabelNode? {
        if let playerScoreNode = (childNode(withName: "playerScoure") as! SKSpriteNode).children.first {
            return playerScoreNode as? SKLabelNode
        }
        return nil
    }
    
    /// Computer score node
    var computerScoreNode: SKLabelNode? {
        if let playerScoreNode = (childNode(withName: "computerScoure") as! SKSpriteNode).children.first {
            return playerScoreNode as? SKLabelNode
        }
        return nil
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    @objc func computerMove() {
        
        viewModel.turn = .computer
        
        let index = self.viewModel.bestMove()
        self.viewModel.insert(at: index)

        run(SKAction.wait(forDuration: 0.5)) {
            let label = SKLabelNode(text: "O")
            label.fontColor = UIColor.black
            
            if let playNodes = self.playTilesNodes {
                playNodes[index].addChild(label)
            }
            self.showGameResult(or: .player)
        }
       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        let touchedNode = nodes(at: location)
        
        guard let first = touchedNode.first else { return }
        
            if first is SKLabelNode, first.name == "Reset" {
                resetGame()
            } else {
                
                if let spriteNode = first as? SKSpriteNode,
                    let playNodes = self.playTilesNodes,
                    playNodes.contains(spriteNode),
                    spriteNode.children.count == 0,
                    let index = playNodes.indexes(of: spriteNode).first {
                    
                    viewModel.insert(at: index)
                    
                    let label = SKLabelNode(text: "X")
                    label.fontColor = UIColor.black
                    spriteNode.addChild(label)
                    
             showGameResult(or: .computer)
                }
            }
    }
    
    /// Show game result
    func showGameResult(or move: Turn) {
        
        switch self.viewModel.result() {
        case .play:
            self.viewModel.turn = move
            if move == Turn.computer {
                computerMove()
            }
        case .wonByComputer:
            print("Computer was won")
            
            computer += 1
            computerScoreNode?.text = "O : \(computer)"
            run(SKAction.wait(forDuration: 0.5)) {
                self.resetGame()
            }
            
        case .wonByPlayer:
            print("Player was won")
            
            player += 1
            playerScoreNode?.text = "X : \(player)"
            run(SKAction.wait(forDuration: 0.5)) {
            self.resetGame()
            }
        case .draw:
            print("Match draw")
            run(SKAction.wait(forDuration: 0.5)) {
            self.resetGame()
            }
        }
    }
    
    /// Clear all field and reset game
    func resetGame() {
        viewModel.newGame()
        if let playNodes = self.playTilesNodes {
            playNodes.forEach({ $0.removeAllChildren() })
        }
    }
    
}

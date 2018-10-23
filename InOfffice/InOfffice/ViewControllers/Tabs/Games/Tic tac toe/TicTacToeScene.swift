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
    
    var playTileBG: SKSpriteNode? {
        if let bgNode = childNode(withName: "playTileBG") as? SKSpriteNode {
            return bgNode
        }
        return nil
    }
    
    /// Play tiles nodes
    var playTilesNodes: [SKSpriteNode]? {
        
        if let bgNode = playTileBG {
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
        self.scoreBG?.isHidden = true
    }
    
    var resultSpriteNode: SKLabelNode?
    
    var scoreBG: SKSpriteNode? {
        if let reset = childNode(withName: "ResultNode") as? SKSpriteNode {
            return reset
        }
        return nil
    }
    
    var scoreTitle: SKLabelNode? {
        if let reset = scoreBG?.children[0] as? SKLabelNode {
            return reset
        }
        return nil
    }
    
    func showResult(title: String) {
        
        scoreBG?.run(SKAction.fadeIn(withDuration: 0.5))
        self.scoreTitle?.text = title
        self.scoreBG?.isHidden = false
    }
    
    func hideResult() {
        
        scoreBG?.run(SKAction.fadeOut(withDuration: 0.5)) {
            self.scoreBG?.isHidden = true
            self.scoreTitle?.text = ""
        }
    }
    
    @objc func computerMove() {
        
        viewModel.turn = .computer
        
        let index = self.viewModel.bestMove()
        self.viewModel.insert(at: index, doneBy: .computer)
        
        run(SKAction.wait(forDuration: 0.5)) {
            let label = SKLabelNode(text: "O")
            label.fontColor = UIColor.black
            
            if let playNodes = self.playTilesNodes {
                playNodes[index].addChild(label)
                
                self.run(SKAction.playSoundFileNamed("computerMoved.wav", waitForCompletion: false))
            }
            self.showGameResult(or: .player)
            self.isUserInteractionEnabled = true
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
            
            if let spriteNode = first as? SKSpriteNode, let playNodes = self.playTilesNodes, playNodes.contains(spriteNode), spriteNode.children.count == 0, let index = playNodes.indexes(of: spriteNode).first {
                
                self.isUserInteractionEnabled = false

                viewModel.insert(at: index, doneBy: .player)
                
                let label = SKLabelNode(text: "X")
                label.fontColor = UIColor.black
                spriteNode.addChild(label)
                
                self.run(SKAction.playSoundFileNamed("playerMoved.wav", waitForCompletion: false))

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
            computer += 1
            computerScoreNode?.text = "O : \(computer)"
            run(SKAction.wait(forDuration: 0.5)) {
                self.showResult(title: "O Won")
                self.viewModel.lastWon = .computer
                self.run(SKAction.playSoundFileNamed("computerWon.wav", waitForCompletion: false))
            }
            
        case .wonByPlayer:
            player += 1
            playerScoreNode?.text = "X : \(player)"
            run(SKAction.wait(forDuration: 0.5)) {
                self.showResult(title: "X Won")
                self.viewModel.lastWon = .player
                self.run(SKAction.playSoundFileNamed("scored.wav", waitForCompletion: false))
            }
        case .draw:
            run(SKAction.wait(forDuration: 0.5)) {
                self.showResult(title: "Draw")
                self.run(SKAction.playSoundFileNamed("ThroatMale.wav", waitForCompletion: false))
            }
        }
        
        self.isUserInteractionEnabled = true
    }
    
    /// Clear all field and reset game
    func resetGame() {
        self.isUserInteractionEnabled = false
        if let playNodes = self.playTilesNodes {
            playNodes.forEach({ $0.removeAllChildren() })
        }
        self.isUserInteractionEnabled = true
        viewModel.newGame()
        
        self.run(SKAction.playSoundFileNamed("reset.wav", waitForCompletion: false))

        hideResult()
        
        if viewModel.lastWon == .computer {
            computerMove()
        }
    }

    
}

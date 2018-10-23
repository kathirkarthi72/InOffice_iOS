//
//  JumpGameScene.swift
//  InOfffice
//
//  Created by ktrkathir on 11/10/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import SpriteKit

class JumpGameScene: SKScene {
    
    var viewModel = JumpGameViewModel()
    
    //    Background sprite node
    var bgSpriteNode: SKSpriteNode? {
        if let bgNode = childNode(withName: "bgImage") as? SKSpriteNode {
            return bgNode
        }
        return nil
    }
    
    /// background sprite node copy
    var bgSpriteNodeNext: SKSpriteNode?
    
    // Time since last frame
    var deltaTime : TimeInterval = 0
    
    // Time of last frame
    var lastFrameTime : TimeInterval = 0
    
    var bgSpeed: Float = 50.0
    
    /// Allow to jump
    var allowJump: Bool = true
    
    var ballNode : SKSpriteNode? {
        
        if let ball = self.childNode(withName: "ballNode") as? SKSpriteNode {
            return ball
        }
        return nil
    }
    
    override func didMove(to view: SKView) {
        
        if let bgSprite = bgSpriteNode {
            bgSpriteNodeNext = bgSprite.copy() as? SKSpriteNode
            bgSpriteNodeNext?.position = CGPoint(x: bgSprite.position.x + bgSprite.size.width, y: bgSprite.position.y)
            self.addChild(bgSpriteNodeNext!)
        }
        
        fall()
        rotate()
    }
    
    // when either of the sprites goes off-screen, move it to the
    // right so that it appears to be seamless movement
    func moveSprite(sprite : SKSpriteNode, nextSprite : SKSpriteNode, speed : Float) {
        
        var newPosition = CGPoint.zero
        // For both the sprite and its duplicate:
        for spriteToMove in [sprite, nextSprite] {
            
            // Shift the sprite leftward based on the speed
            newPosition = spriteToMove.position
            newPosition.x -= CGFloat(speed * Float(deltaTime))
            spriteToMove.position = newPosition
            
            // If this sprite is now offscreen (i.e., its rightmost edge is
            // farther left than the scene's leftmost edge):
            if spriteToMove.frame.maxX < self.frame.minX {
                
                // Shift it over so that it's now to the immediate right
                // of the other sprite.
                // This means that the two sprites are effectively
                // leap-frogging each other as they both move.
                spriteToMove.position =
                    CGPoint(x: spriteToMove.position.x +
                        spriteToMove.size.width * 2,
                            y: spriteToMove.position.y)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // First, update the delta time values:
        
        // If we don't have a last frame time value, this is the first frame,
        // so delta time will be zero.
        if lastFrameTime <= 0 {
            lastFrameTime = currentTime
        }
        
        // Update delta time
        deltaTime = currentTime - lastFrameTime
        
        // Set last frame time to current time
        lastFrameTime = currentTime
        
        if let bgNode = bgSpriteNode, let bgNextNode = bgSpriteNodeNext {
            // Next, move each of the four pairs of sprites.
            // Objects that should appear move slower than foreground objects.
            moveSprite(sprite: bgNode, nextSprite: bgNextNode, speed: bgSpeed)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        jump()
    }

    fileprivate func rotate() {
        guard let ballNode = ballNode else { return }
        
        let rotate = SKAction.rotate(byAngle: -CGFloat.pi/4, duration: 1.5)
        let moveToX = SKAction.moveTo(x: -100, duration: 1.5)
        
        let sequence = SKAction.group([rotate, moveToX])
        ballNode.run(SKAction.repeatForever(sequence))
    }
    
    
    
    fileprivate func fall() {
        guard let ballNode = ballNode else { return }
        
        let moveToY = SKAction.moveTo(y: -200, duration: 1.5)
        ballNode.run(moveToY)
    }
    
    /// Jump action
    fileprivate func jump() {
        
        if allowJump {
            allowJump = false
            guard let ballNode = ballNode else { return }
            let moveUp = SKAction.moveTo(y: 0, duration: 0.5)
            let moveDown = SKAction.moveTo(y: -200, duration: 0.5)
            
            let sequence = SKAction.sequence([moveUp, moveDown])
            ballNode.run(sequence) {
                self.allowJump = true
            }
        }
    }
}

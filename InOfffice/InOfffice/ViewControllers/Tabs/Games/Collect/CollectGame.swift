//
//  CollectGame.swift
//  InOfffice
//
//  Created by ktrkathir on 30/10/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import Foundation
import SpriteKit

struct CollectPhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let enemy   : UInt32 = 0b1       // 1
    static let avatar: UInt32 = 0b10      // 2
}

struct Property {
    var title: String
    var icon: String
}

class CollectGame: SKScene {
    
    var bgSprite: SKSpriteNode?
    
    var avatorSprite: SKSpriteNode?
    
    var fingerIsTouching: Bool = false
    
    var travelledDistance: Int = 0
    
    var timer: Timer?
    
    var inteval: TimeInterval = 0.5
    
    let collectTypes: [Property] = [Property(title: "enemy", icon: "Bug1"),
                                    Property(title: "enemy", icon: "Bug2"),
                                    Property(title: "collect", icon: "fruit1"),
                                    Property(title: "collect", icon: "fruit2"),
                                    Property(title: "collect", icon: "fruit3"),
                                    Property(title: "collect", icon: "fruit4"),
                                    Property(title: "collect", icon: "fruit5")]
    
    var gameOverBGSprite: SKSpriteNode? {
        return childNode(withName: "gameOverScene") as? SKSpriteNode
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        gameOverBGSprite?.isHidden = true
        physicsWorld.contactDelegate = self
        
        self.perform(#selector(newGame), with: nil, afterDelay: 1.0)
    }
    
    func addBgSprite() {
        bgSprite = SKSpriteNode(imageNamed: "collectBG")
        bgSprite?.size = CGSize(width: self.frame.size.width, height:self.frame.size.height)
        self.addChild(bgSprite!)
        
        bgSpriteNodeNext = bgSprite!.copy() as? SKSpriteNode
        bgSpriteNodeNext?.position = CGPoint(x: bgSprite!.position.x + bgSprite!.size.width, y: bgSprite!.position.y)
        self.addChild(bgSpriteNodeNext!)
    }
    
    /// background sprite node copy
    var bgSpriteNodeNext: SKSpriteNode?
    
    // Time since last frame
    var deltaTime : TimeInterval = 0
    
    // Time of last frame
    var lastFrameTime : TimeInterval = 0
    
    var bgSpeed: Float = 0.0
    
    func addAvator() {        
        let texture = SKTexture(imageNamed: "Jetpack")
        avatorSprite = SKSpriteNode(texture: texture)
        avatorSprite?.name = "Avatar"
        avatorSprite?.position = CGPoint(x: self.frame.midX - 100, y: self.frame.maxY)
        avatorSprite?.size = CGSize(width: 90.0, height: 90.0)
        avatorSprite?.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        avatorSprite?.zPosition = 3
        //        avatorSprite?.xScale = 0.1
        //        avatorSprite?.xScale = 0.1
        avatorSprite?.physicsBody =  SKPhysicsBody(texture: texture, alphaThreshold: 0.7, size: avatorSprite?.size ?? CGSize.zero) //SKPhysicsBody(texture: spaceShipTexture, size: CGSize(width: 90.0, height: 90.0))
        avatorSprite?.physicsBody?.isDynamic = true
        avatorSprite?.physicsBody?.allowsRotation = false
        avatorSprite?.physicsBody?.affectedByGravity = false
        //        avatorSprite?.physicsBody?.categoryBitMask = CollectPhysicsCategory.avatar // 3
        //        avatorSprite?.physicsBody?.contactTestBitMask = CollectPhysicsCategory.enemy // 4
        //        avatorSprite?.physicsBody?.collisionBitMask = CollectPhysicsCategory.none // 5
        self.addChild(avatorSprite!)
        
        initialFall()
    }
    
    @objc func addEnemy() {
        
        let object = collectTypes.randomElement()
        
        var yPosition : CGFloat = 0.0
        
        if object?.title == "enemy" {
            let mid = avatorSprite!.position.y - 100
            let max = avatorSprite!.position.y + 100
            
            let range = [mid...max]
            yPosition = CGFloat.random(in: range.first!)
        } else {
            let range = [self.frame.midY...self.frame.maxY]
            yPosition = CGFloat.random(in: range.first!)
        }
        
        let spaceShipTexture = SKTexture(imageNamed: object!.icon)
        
        let enemySprite = SKSpriteNode(imageNamed: object!.icon)
        enemySprite.name = object!.title
        enemySprite.position = CGPoint(x: self.frame.maxX, y: yPosition)
        enemySprite.size = CGSize(width: 25.0, height: 25.0)
        enemySprite.zPosition = 3
        enemySprite.physicsBody = SKPhysicsBody(texture: spaceShipTexture, size: CGSize(width: 25.0, height: 25.0))
        enemySprite.physicsBody?.isDynamic = true
        enemySprite.physicsBody?.allowsRotation = false
        enemySprite.physicsBody?.affectedByGravity = false
        enemySprite.physicsBody?.categoryBitMask = CollectPhysicsCategory.enemy // 3
        enemySprite.physicsBody?.contactTestBitMask = CollectPhysicsCategory.avatar // 4
        enemySprite.physicsBody?.collisionBitMask = CollectPhysicsCategory.none // 5
        self.addChild(enemySprite)
        
        if object?.title == "enemy" {
            moveOn(node: enemySprite)
        } else {
            moveOn(node: enemySprite, withRotate: true)
        }
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
                spriteToMove.position = CGPoint(x: spriteToMove.position.x + spriteToMove.size.width * 2, y: spriteToMove.position.y)
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
        
        if gameOverBGSprite!.isHidden {
            travelledDistance += 1
            print(String(travelledDistance))
        }
        
        // Update delta time
        deltaTime = currentTime - lastFrameTime
        
        // Set last frame time to current time
        lastFrameTime = currentTime
        
        if let bgNode = bgSprite, let bgNextNode = bgSpriteNodeNext {
            // Next, move each of the four pairs of sprites.
            // Objects that should appear move slower than foreground objects.
            moveSprite(sprite: bgNode, nextSprite: bgNextNode, speed: bgSpeed)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let gameover = gameOverBGSprite, !gameover.isHidden {
            newGame()
        } else {
            fingerIsTouching = true
            touchOn()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fingerIsTouching = false
        
        if gameOverBGSprite!.isHidden {
            fingerIsTouching = false
        }
    }
    
    // Initial fall
    func initialFall() {
        guard let avatar = avatorSprite else { return }
        let moveToY = SKAction.moveTo(y: self.frame.minY + 20, duration: 4.0)
        //  let moveToX = SKAction.moveTo(x: self.frame.minY, duration: 1.5)
        avatar.run(moveToY) {
            self.gameOver()
        }
    }
    
    func jumpAction() {
        guard let avatar = avatorSprite else { return }
        let moveUp = SKAction.moveBy(x: 0, y: 20, duration: 0.2)
        
        avatar.run(moveUp) {
            if self.fingerIsTouching {
                self.jumpAction()
            } else {
                
                if avatar.hasActions() {
                    avatar.removeAllActions()
                }
                
                let moveDown = SKAction.moveTo(y: self.frame.minY + 20, duration: avatar.position.x > 0 ? 4.0 : 1.5)
                avatar.run(moveDown) {
                    self.gameOver()
                }
            }
        }
    }
    
    /// Touched on
    func touchOn() {
        guard let avatar = avatorSprite else { return }
        if avatar.hasActions() {
            avatar.removeAllActions()
        }
        jumpAction()
    }
    
    func moveOn(node: SKSpriteNode, withRotate: Bool = false) {
        
        if withRotate {
            let slide = SKAction.moveTo(x: self.frame.minX, duration: 4.0)
            let rotate = SKAction.rotate(byAngle: CGFloat.pi, duration: 2.0)
            
            node.run(SKAction.group([slide, SKAction.repeatForever(rotate)])) {
                node.removeFromParent()
            }
        } else {
            let slide = SKAction.moveTo(x: self.frame.minX, duration: 4.0)
            node.run(slide) {
                node.removeFromParent()
            }
        }
    }
    
    @objc func newGame() {
        gameOverBGSprite?.isHidden = true
        addBgSprite()
        addAvator()
        bgSpeed = 30.0
        
        timer = Timer.scheduledTimer(timeInterval: inteval, target: self, selector: #selector(addEnemy), userInfo: nil, repeats: true)
    }
    
    func gameOver() {
        
        if timer!.isValid {
            timer?.invalidate()
        }
        
        gameOverBGSprite?.isHidden = false
        gameOverBGSprite?.position = CGPoint(x: 0, y: 0)
        
        avatorSprite?.removeAllActions()
        bgSpeed = 0.0
        travelledDistance = 0
        
        children.forEach { (node) in
            if node.name == "enemy" || node.name == "collect" {
                node.removeAllActions()
                node.removeFromParent()
            }
        }
        
        avatorSprite?.removeFromParent()
        bgSprite?.removeFromParent()
        bgSpriteNodeNext?.removeFromParent()
    }
}

extension CollectGame: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "collect" || nodeA.name == "enemy" {
            collisied(collected: nodeA)
        } else if nodeB.name == "collect" || nodeB.name == "enemy" {
            collisied(collected: nodeB)
        }
    }
    
    func collisied(collected: SKNode) {
        
        if collected.name == "collect" {
        }
        
        collected.removeFromParent()
    }
}

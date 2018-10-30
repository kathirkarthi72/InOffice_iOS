//
//  JumpGameScene.swift
//  InOfffice
//
//  Created by ktrkathir on 11/10/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import SpriteKit
import CoreMotion

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let wood   : UInt32 = 0b1       // 1
    static let projectile: UInt32 = 0b10      // 2
}

class JumpGameScene: SKScene {
    
    var viewModel = JumpGameViewModel()
    
    let  motionManager: CMMotionManager = CMMotionManager()
    
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
    
    var avatorNode : SKSpriteNode? {
        
        if let ball = self.childNode(withName: "ballNode") as? SKSpriteNode {
            return ball
        }
        return nil
    }
    
    var jumpFrames: [SKTexture] = []
    
    func buildAvator() {
        let bearAnimatedAtlas = SKTextureAtlas(named: "Jump")
        var walkFrames: [SKTexture] = []
        
        let numImages = bearAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let bearTextureName = "tile00\(i)"
            walkFrames.append(bearAnimatedAtlas.textureNamed(bearTextureName))
        }
        jumpFrames = walkFrames
    }
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        buildAvator()
        monitorUserActivity()
        
        if let bgSprite = bgSpriteNode {
            bgSpriteNodeNext = bgSprite.copy() as? SKSpriteNode
            bgSpriteNodeNext?.position = CGPoint(x: bgSprite.position.x + bgSprite.size.width, y: bgSprite.position.y)
            self.addChild(bgSpriteNodeNext!)
        }
        
        physicsWorld.contactDelegate = self
        
        initialFall()
        createScoreNode()
        
        self.perform(#selector(createWood), with: nil, afterDelay: 1.0)
        
    }
    
    var woodSprite: SKSpriteNode = SKSpriteNode()
    
    let cars: [String] = ["Car1", "Car2", "Car3"]
    
    @objc func createWood() {
        
        woodSprite = SKSpriteNode(imageNamed: cars.randomElement()!)
        woodSprite.name = "Car"
        woodSprite.zPosition = 2
        woodSprite.position = CGPoint(x: self.frame.maxX , y: -225)
        woodSprite.size = CGSize(width: 50, height: 50)
        woodSprite.physicsBody = SKPhysicsBody(rectangleOf: woodSprite.size)
        woodSprite.physicsBody?.isDynamic = true
        woodSprite.physicsBody?.allowsRotation = true
        woodSprite.physicsBody?.affectedByGravity = false
        woodSprite.physicsBody?.categoryBitMask = PhysicsCategory.wood // 3
        woodSprite.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
        woodSprite.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        addChild(woodSprite)
        
        let slide = SKAction.moveTo(x: self.frame.minX, duration: 2.5)
        
        woodSprite.run(SKAction.sequence([slide])) {
            self.woodSprite.removeFromParent()
            self.viewModel.score += 1
            self.updateScore()
            
            self.perform(#selector(self.createWood), with: nil, afterDelay: 1.0)
        }
    }
    
    /// Create score node
    func createScoreNode() {
        let attributed = NSMutableAttributedString(string: "Score :", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25)])
        let value = NSAttributedString(string: "0", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)])
        
        attributed.append(value)
        
        let scoreLabel = SKLabelNode(attributedText: attributed)
        scoreLabel.zPosition = 10
        scoreLabel.position = CGPoint(x: frame.midX, y: 280)
        addChild(scoreLabel)
        
        scoreNode = scoreLabel
    }
    
    /// Score node
    var scoreNode: SKLabelNode?
    
    /// Update node
    func updateScore() {
        
        if let node = scoreNode {
            let attributed = NSMutableAttributedString(string: "Score :", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25)])
            let value = NSAttributedString(string: String(viewModel.score), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)])
            
            attributed.append(value)
            
            node.attributedText = attributed
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
        touchOn()
    }
    
    /// node Touched
    ///
    /// - Parameter node: node
    func touchOn() {
        
        if bgSpeed == 0 {
            woodSprite.removeFromParent()
            bgSpeed = 50.0
            viewModel.score = 0
            
            updateScore()
            
            guard let ballNode = avatorNode else { return }
            ballNode.texture = jumpFrames[4]
            ballNode.position = CGPoint(x: -100, y: -200)
            
            self.perform(#selector(createWood), with: nil, afterDelay: 1.0)
        }
        
        jump()
    }
    
    
}

extension JumpGameScene {
    
    func monitorUserActivity() {
        motionManager.deviceMotionUpdateInterval = 0.05
        
        if motionManager.isDeviceMotionAvailable {
            
            motionManager.startDeviceMotionUpdates(to: .main) { (deviceMotion, error) in
                
                let userAcceleration = deviceMotion!.userAcceleration
                let gravity = userAcceleration.y + 1.0 * 9.81
                
                
                let requiredAcceleration = 10 + self.viewModel.selectedHeight / self.viewModel.requiredJumpAccelerationScaleFactor
                
                print("Y: = \(userAcceleration.y), Gravity: \(gravity)")
                
                if gravity > requiredAcceleration {
                    print("Jumped")
                    self.jump()
                }
                /*else {
                 
                 let sitRequiredAcceleration = 1 + self.viewModel.selectedSitHeight / self.viewModel.requiredSitAccelerationScaleFactor
                 print("Sit = \(sitRequiredAcceleration)")
                 }
                 */
            }
            
        }
    }
}

// MARK: Avator animations
extension JumpGameScene {
    /// Initial fall
    fileprivate func initialFall() {
        
        guard let ballNode = avatorNode else { return }
        
        let atlas = [jumpFrames[2], jumpFrames[3], jumpFrames[4]]
        
        let fall = SKAction.animate(with: atlas, timePerFrame: 0.25)
        let moveToY = SKAction.moveTo(y: -200, duration: 1.0)
        let moveToX = SKAction.moveTo(x: -100, duration: 1.0)
        let sequence = SKAction.group([moveToX, moveToY, fall])
        ballNode.run(sequence)
    }
    
    /// Jump action
    fileprivate func jump() {
        
        if allowJump {
            allowJump = false
            
            guard let ballNode = avatorNode else { return }
            let highUp = SKAction.moveTo(y: -100, duration: 0.5)
            let down = SKAction.moveTo(y: -200, duration: 0.5)
            let moveToX = SKAction.moveTo(x: -100, duration: 1.0)
            
            // let smallJump = SKAction.moveTo(y: -150, duration: 0.2)
            // let smallDown = SKAction.moveTo(y: -195, duration: 0.3)
            
            let jump = SKAction.animate(with: jumpFrames, timePerFrame: 0.2, resize: false, restore: true)
            let stand = SKAction.rotate(toAngle: 0.0, duration: 1.0)
            
            let sequence = SKAction.sequence([highUp, down])
            let grouped = SKAction.group([sequence, moveToX, jump, stand])
            
            ballNode.run(grouped) {
                self.allowJump = true
            }
        }
    }
    
    fileprivate func die(with car: SKNode) {
        
        guard let avator = avatorNode else { return }
        let rotate = SKAction.rotate(toAngle: 1.6, duration: 0.1)
        let moveToX = SKAction.moveTo(x: -140, duration: 0.5)
        let flat = SKAction.moveTo(y: -230, duration: 0.5)
        
        avator.run(SKAction.group([rotate, moveToX, flat]))
    }
    
    /// Sit action
    /*   fileprivate func sit() {
     
     if allowJump {
     allowJump = false
     
     guard let ballNode = ballNode else { return }
     
     let sit = SKAction.moveTo(y: -250, duration: 0.5)
     let down = SKAction.moveTo(y: -200, duration: 0.5)
     
     let sitFrames = [jumpFrames[3],jumpFrames[4]]
     
     let jump = SKAction.animate(with: sitFrames, timePerFrame: 0.2, resize: false, restore: true)
     
     let sequence = SKAction.sequence([sit, down])
     let grouped = SKAction.group([sequence, jump])
     
     ballNode.run(grouped) {
     self.allowJump = true
     }
     }
     }
     */
}

extension JumpGameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "Car" {
            collisionBetween(ball: nodeB, car: nodeA)
        } else if nodeB.name == "Car" {
            collisionBetween(ball: nodeA, car: nodeB)
        }
    }
    
    func collisionBetween(ball: SKNode, car: SKNode) {
        car.removeAllActions()
        viewModel.score = 0
        bgSpeed = 0
        die(with: car)
    }
}

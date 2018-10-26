//
//  JumpGameScene.swift
//  InOfffice
//
//  Created by ktrkathir on 11/10/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let wood   : UInt32 = 0b1       // 1
    static let projectile: UInt32 = 0b10      // 2
}

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
    
    enum BallImageTypes: String {
        case ball = "Soccer-Ball"
        case tire = "tire"
        
        mutating func next() {
            switch self {
            case .ball:
                self = .tire
            default:
                self = .ball
            }
        }
    }
    
    var ballType: BallImageTypes = .ball
    
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
        
        physicsWorld.contactDelegate = self
        
        initialFall()
        createWood()
        createScoreNode()
    }
 
    var woodSprite: SKSpriteNode = SKSpriteNode()
    
    func createWood() {
        
        if let ball = ballNode {
            if ball.position.y == 0 {
                woodSprite = SKSpriteNode(imageNamed: "wood")
                woodSprite.name = "wood"
                woodSprite.zPosition = 2
                woodSprite.position = CGPoint(x: self.frame.maxX , y: 0)
                woodSprite.size = CGSize(width: 50, height: 50)
                woodSprite.physicsBody = SKPhysicsBody(rectangleOf: woodSprite.size)
                woodSprite.physicsBody?.isDynamic = true
                woodSprite.physicsBody?.allowsRotation = true
                woodSprite.physicsBody?.affectedByGravity = false
                woodSprite.physicsBody?.categoryBitMask = PhysicsCategory.wood // 3
                woodSprite.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
                woodSprite.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
                addChild(woodSprite)
                
                let slide = SKAction.moveTo(x: self.frame.minX, duration: 2.0)
                woodSprite.run(slide) {
                    self.woodSprite.removeFromParent()
                    self.createWood()
                    self.viewModel.score += 1
                    self.updateScore()
                }
                
            } else {
                woodSprite = SKSpriteNode(imageNamed: "wood")
                woodSprite.name = "wood"
                woodSprite.zPosition = 2
                woodSprite.position = CGPoint(x: self.frame.maxX , y: self.frame.midY)
                woodSprite.size = CGSize(width: 50, height: 50)
                woodSprite.physicsBody = SKPhysicsBody(rectangleOf: woodSprite.size)
                woodSprite.physicsBody?.isDynamic = true
                woodSprite.physicsBody?.allowsRotation = true
                woodSprite.physicsBody?.affectedByGravity = false
                woodSprite.physicsBody?.categoryBitMask = PhysicsCategory.wood // 3
                woodSprite.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
                woodSprite.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
                addChild(woodSprite)
                
                let move = SKAction.moveTo(y: -210, duration: 1.0)
                let slide = SKAction.moveTo(x: self.frame.minX, duration: 2.0)
                
                woodSprite.run(SKAction.sequence([move, slide])) {
                    self.woodSprite.removeFromParent()
                    self.createWood()
                    self.viewModel.score += 1
                    self.updateScore()
                }
            }
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
        
        if bgSpeed == 0 {
            woodSprite.removeFromParent()
            bgSpeed = 50.0
            createWood()
            viewModel.score += 1

            updateScore()
            
            rotate()
            jump()
        }
        
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        guard let touchedNode = nodes(at: location).first else { return }
        
        touchOn(node: touchedNode)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        guard let touchedNode = nodes(at: location).first else { return }
        
        touchOff(node: touchedNode)
    }
    
    /// node Touched
    ///
    /// - Parameter node: node
    func touchOn(node: SKNode) {
        if node.name == "bgImage" {
            jump()
        } else if node.name == "ballNode" {
            if let ball = node as? SKSpriteNode {
                ballType.next()
                ball.texture = SKTexture(imageNamed: ballType.rawValue)
            }
        }
    }
    
    func touchOff(node: SKNode) {
        if node.name == "bgImage" {
            drop()
        }
    }
    
    fileprivate func rotate() {
        guard let ballNode = ballNode else { return }
        
        let rotate = SKAction.rotate(byAngle: -CGFloat.pi/4, duration: 1.5)
        let moveToX = SKAction.moveTo(x: -100, duration: 1.5)
        
        let sequence = SKAction.group([rotate, moveToX])
        ballNode.run(SKAction.repeatForever(sequence))
    }
    
    /// Initial fall
    fileprivate func initialFall() {
        guard let ballNode = ballNode else { return }
        
        let moveToY = SKAction.moveTo(y: -200, duration: 1.0)

        let smallJump = SKAction.moveTo(y: -150, duration: 0.2)
        let smallDown = SKAction.moveTo(y: -195, duration: 0.3)
        
        let sequence = SKAction.sequence([moveToY, smallJump, smallDown])

        ballNode.run(sequence) {
            self.rotate()
        }
    }
    
    /// Jump action
    fileprivate func jump() {
        
        if allowJump {
            allowJump = false
            guard let ballNode = ballNode else { return }
            let highUp = SKAction.moveTo(y: 0, duration: 0.5)
          
            let sequence = SKAction.sequence([highUp])
            ballNode.run(sequence)
        }
    }
    
    /// Fall down
    fileprivate func drop() {
        
        guard let ballNode = ballNode else { return }
        let down = SKAction.moveTo(y: -200, duration: 0.5)
        let smallJump = SKAction.moveTo(y: -150, duration: 0.2)
        let smallDown = SKAction.moveTo(y: -195, duration: 0.3)
        
        let sequence = SKAction.sequence([down, smallJump, smallDown])
        ballNode.run(sequence) {
            self.allowJump = true
        }
    }
}

extension JumpGameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "wood" {
            collisionBetween(ball: nodeB, wood: nodeA)
        } else if nodeB.name == "wood" {
            collisionBetween(ball: nodeA, wood: nodeB)
        }
    }
    
    func collisionBetween(ball: SKNode, wood: SKNode) {
        wood.removeAllActions()
        viewModel.score = 0
        bgSpeed = 0
    }
}

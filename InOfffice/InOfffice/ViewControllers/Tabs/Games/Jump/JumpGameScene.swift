//
//  JumpGameScene.swift
//  InOfffice
//
//  Created by ktrkathir on 11/10/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import Foundation
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
    
    // Is user tapped on screen. Taking photo actionw is processing
    var isTakingPhoto: Bool = false
    
    var walkTextureAtlas : SKTextureAtlas = SKTextureAtlas(named: "WalkSprites")
    var takePhotoTextureAtlas : SKTextureAtlas = SKTextureAtlas(named: "TapPhotoSprites")
    
    var walkTextures : [SKTexture] {
        
        var textures : [SKTexture] = []
        
        for item in 0..<walkTextureAtlas.textureNames.count {
            textures.append(walkTextureAtlas.textureNamed(walkTextureAtlas.textureNames[item]))
        }
        
        return textures
    }
    
    var takePhotoTextures : [SKTexture] {
        
        var textures : [SKTexture] = []
        
        for item in 0..<takePhotoTextureAtlas.textureNames.count {
            textures.append(takePhotoTextureAtlas.textureNamed(takePhotoTextureAtlas.textureNames[item]))
        }
        return textures
    }
    
    var walkingSpriteNode: SKSpriteNode!
    
    fileprivate func walkAniamtion() {
        let myAnimation = SKAction.animate(with: walkTextures, timePerFrame: 1.0)
        walkingSpriteNode.run(SKAction.repeatForever(myAnimation))
    }
    
    fileprivate func takePhotoAnimation() {
        let takephoto = SKAction.animate(with: takePhotoTextures, timePerFrame: 1.0)
        walkingSpriteNode.run(takephoto)
    }
    
    override func didMove(to view: SKView) {
        
        walkingSpriteNode = SKSpriteNode(texture: walkTextureAtlas.textureNamed("tile013"))
        walkingSpriteNode.zPosition = 1
        walkingSpriteNode.position = CGPoint(x: -120, y: -180)
        addChild(walkingSpriteNode)
        
        walkAniamtion()
        
        if let bgSprite = bgSpriteNode {
            bgSpriteNodeNext = bgSprite.copy() as? SKSpriteNode
            bgSpriteNodeNext?.position = CGPoint(x: bgSprite.position.x + bgSprite.size.width, y: bgSprite.position.y)
            self.addChild(bgSpriteNodeNext!)
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
                spriteToMove.position =
                    CGPoint(x: spriteToMove.position.x +
                        spriteToMove.size.width * 2,
                            y: spriteToMove.position.y)
            }
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if !isTakingPhoto {
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
                moveSprite(sprite: bgNode, nextSprite: bgNextNode, speed: 100.0)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !walkingSpriteNode.hasActions() {
            isTakingPhoto = false
            walkAniamtion()
        } else {
            isTakingPhoto = true
            walkingSpriteNode.removeAllActions()
            takePhotoAnimation()
        }
        
    }
}

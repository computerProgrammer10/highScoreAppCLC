//
//  GameScene.swift
//  foreverGameCLCApp
//
//  Created by DANIEL HUSEBY on 2/25/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let cam = SKCameraNode()
    
    var player: SKSpriteNode!
    
    var inAir = false
    
    var goingLeft = false
    
    var dashing = false
    
    var runSpeed = 500
    
    override func didMove(to view: SKView) {
        self.camera = cam
        
        player = self.childNode(withName: "player") as! SKSpriteNode
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        physicsWorld.contactDelegate = self
        print("WEEEE")
        let nodeA = contact.bodyA.node!
        let nodeB = contact.bodyB.node!
        
        if nodeA.name == "ground" || nodeB.name == "ground" {
            inAir = false
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if !inAir {
            player.physicsBody?.velocity.dy = 1000
            inAir = true
        } else {
            player.physicsBody?.velocity.dx = (2000 * (goingLeft ? -1 : 1))
            dashing = true
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        cam.position = player.position
        
        if dashing {
            player.physicsBody?.velocity.dx -= 100 * (goingLeft ? -1 : 1)
            
            player.physicsBody?.velocity.dx *= ((player.physicsBody?.velocity.dx)! < 0.0 ? -1 : 1)
            
            if (player.physicsBody?.velocity.dx)! < CGFloat(runSpeed) {
                dashing = false
                player.physicsBody?.velocity.dx = CGFloat(runSpeed * (goingLeft ? -1 : 1))
            }
        }
    }
}

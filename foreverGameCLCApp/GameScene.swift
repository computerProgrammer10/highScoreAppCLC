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
    
    var onWall = false
    
    var jumping = false
    
    var dashAvailable = true
    
    var runSpeed = 500
    
    override func didMove(to view: SKView) {
        self.camera = cam
        physicsWorld.contactDelegate = self
        
        player = self.childNode(withName: "player") as! SKSpriteNode
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("WEEEE")
        let nodeA = contact.bodyA.node!
        let nodeB = contact.bodyB.node!
        
        if (nodeA.name == "ground" || nodeB.name == "ground") && (nodeA.name == "player" || nodeB.name == "player") {
            
//            detect if the y of the "collision direction" vector is less than the x
//            if so, it collided on the left / right
            
//            if not, it collided on top / bottom
            if abs(contact.contactNormal.dy) < abs(contact.contactNormal.dx) {
                onWall = true
                print("me on wall?")
            }
            
            inAir = false
            dashAvailable = true
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if !inAir {
            player.physicsBody?.velocity.dy = 1000
            inAir = true
            jumping = true
            if onWall {
                print("WALL JOOMP")
                goingLeft = !goingLeft
                onWall = false
                player.physicsBody?.velocity.dx = CGFloat(runSpeed * (goingLeft ? -1 : 1))
            }
        } else if dashAvailable {
            player.physicsBody?.velocity.dx = (3000 * (goingLeft ? -1 : 1))
            dashing = true
            dashAvailable = false
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if jumping {
            player.physicsBody?.velocity.dy = 0
        }
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
        
        if jumping && (player.physicsBody?.velocity.dy)! < 0 {
            jumping = false
        }
        
        if onWall {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        if dashing {
            player.physicsBody?.velocity.dx -= 100 * (goingLeft ? -1 : 1)
            
            if (abs(player.physicsBody?.velocity.dx as! CGFloat)) < CGFloat(runSpeed) {
                dashing = false
            }
        } else {
            
        }
    }
}

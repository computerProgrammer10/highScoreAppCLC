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
    
    override func didMove(to view: SKView) {
        self.camera = cam
        
        player = self.childNode(withName: "player") as! SKSpriteNode
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
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
            player.position.x += (500 * (goingLeft ? -1 : 1))
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
    }
}

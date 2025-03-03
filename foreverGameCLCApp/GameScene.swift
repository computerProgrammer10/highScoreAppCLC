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
    
    var dieThing: SKSpriteNode!
    
    var inAir = false
    
    var goingLeft = false
    
    var dashing = false
    
    var onWall = false
    
    var jumping = false
    
    var playerDead = true
    
    var dashAvailable = true
    
    var runSpeed = 500
    
    var coins = 0
    
    var coinLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        self.camera = cam
        self.addChild(cam)
        
        coinLabel = SKLabelNode(text: "coins: 0")
        coinLabel.fontSize = 40
        coinLabel.fontName = "Helvetica Neue Medium"
        
        coinLabel.position = CGPoint(x: -200, y: 600)
        cam.addChild(coinLabel)
        
        player = self.childNode(withName: "player") as! SKSpriteNode
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if playerDead {
            return
        }
//        print("WEEEE")
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
        
        if  (nodeA.name == "coin" || nodeB.name == "coin") && (nodeA.name == "player" || nodeB.name == "player") {
            let coin = (nodeA.name == "coin" ? nodeA : nodeB)
            
            coin.removeFromParent() // destroy the coin
            
            coins += 1
            
            coinLabel.text = "coins: \(coins)"
            
        }
        
        if  (nodeA.name == "spike" || nodeB.name == "spike") && (nodeA.name == "player" || nodeB.name == "player") {
            let spike = (nodeA.name == "spike" ? nodeA : nodeB)
            print("WAAAAAAAAAAAgg")
            player.physicsBody!.friction = 10
            player.physicsBody?.allowsRotation = true
            
            playerDead = true
            
            var background = SKSpriteNode(color: .gray, size: CGSize(width: self.size.width, height: self.size.height))
            
            background.alpha = 0.5
            
            let texty = SKLabelNode(text: "you died lol")
            texty.fontSize = 40
            texty.fontName = "Helvetica Neue Medium"
            
            background.addChild(texty)
            
            self.addChild(background)
            
            dieThing = background
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if playerDead {
            return
        }
        
        let nodeA = contact.bodyA.node!
        let nodeB = contact.bodyB.node!
        
        if (nodeA.name == "ground" || nodeB.name == "ground") && (nodeA.name == "player" || nodeB.name == "player") {
            
//            detect if the y of the "collision direction" vector is less than the x
//            if so, it collided on the left / right
            
//            if not, it collided on top / bottom
            if onWall {
                goingLeft = !goingLeft
                onWall = false
                player.physicsBody?.velocity.dx = CGFloat(runSpeed * (goingLeft ? -1 : 1))
                print("me no on wall?")
            }
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if playerDead {
            dieThing.removeFromParent()
            playerDead = false
            player.position = CGPoint(x: 0, y: 0)
            player.physicsBody!.friction = 0
            player.physicsBody?.allowsRotation = false
            
            return
        }
        if (isPaused) {return}// force the function to not happen if the game is paused
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
        if (isPaused) {return}// force the function to not happen if the game is paused
        if jumping {
            player.physicsBody?.velocity.dy *= 0.5
            player.physicsBody?.velocity.dy -= 20
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
    
    func reset(){
        coins = 0
        player.position = CGPoint(x: 0.0, y: 0.0)
        player.physicsBody?.velocity = CGVector(dx: 500, dy: 0)
    }

    
    override func update(_ currentTime: TimeInterval) {
        cam.position = player.position
        if player.position.y <= -200{
            reset()
        }
        
        if playerDead {
            return
        }
        
        if jumping && (player.physicsBody?.velocity.dy)! < 0 {
            jumping = false
        }
        
        if onWall {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: -50)
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

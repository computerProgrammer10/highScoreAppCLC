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
    
    var viewController: GameViewController!
    
    var gamePaused = false
    
    var inAir = false
    
    var goingLeft = false
    
    var dashing = false
    
    var onWall = false
    
    var jumping = false
    
    var playerDead = false
    
    var dashAvailable = true
    
    var runSpeed = 500
    
    var coins = 0
    
    var stage = 1
    
    var coinLabel: SKLabelNode!
    
    var highScoreLabel: SKLabelNode!
    
    var stageLabel: SKLabelNode!
    
    var initialSpawn: SKNode!
    
    var curObstacle: SKNode!
    
    var curObstacles = [SKNode]()
    
    override func didMove(to view: SKView) {
        if !AppData.isData(){
            AppData.curSave = Save()
        }
        physicsWorld.contactDelegate = self
        
        self.camera = cam
        self.addChild(cam)
        
//        cam.xScale = 10
//        cam.yScale = 10
        
        // label making
        coinLabel = SKLabelNode(text: "coins: 0")
        coinLabel.fontSize = 40
        coinLabel.fontName = "Helvetica Neue Medium"
        coinLabel.fontColor = UIColor.yellow
        
        coinLabel.position = CGPoint(x: -200, y: 600)
        
        
//        highScoreLabel = SKLabelNode(text: "highest score: \(AppData.curSave.highScore)")
//        highScoreLabel.fontSize = 40
//        highScoreLabel.fontName = "Helvetica Neue Medium"
//        
//        highScoreLabel.position = CGPoint(x: -120, y: 500)
        
        stageLabel = SKLabelNode(text: "stage: \(stage)")
        stageLabel.fontSize = 40
        stageLabel.fontName = "Helvetica Neue Medium"
        
        stageLabel.position = CGPoint(x: -200, y: 500)
        
        cam.addChild(coinLabel)
        cam.addChild(stageLabel)
        
        player = self.childNode(withName: "player") as! SKSpriteNode
        
        initialSpawn = self.childNode(withName: "firstobstacleposition")
        
        var obstacleNodes = [SKNode]()
        
        for i in 0...3 {
            let nodey = self.childNode(withName: "obstacle\(i)")!
            obstacleNodes.append(nodey)
            nodey.removeFromParent()
        }
        
        
        Obstacle(node: obstacleNodes[0], direction: "vertical", difficulty: "easy")
        
        Obstacle(node: obstacleNodes[1], direction: "horizontal", difficulty: "easy")
        
        Obstacle(node: obstacleNodes[2], direction: "horizontal", difficulty: "medium")
        
        Obstacle(node: obstacleNodes[3], direction: "vertical", difficulty: "medium")
        
        while curObstacles.count < 3 {
            spawnNextObstacle()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if playerDead {
            return
        }
        let nodeA = contact.bodyA.node!
        let nodeB = contact.bodyB.node!
        
        if (nodeA.name == "ground" || nodeB.name == "ground") && (nodeA.name == "player" || nodeB.name == "player") {
            
//            detect if the y of the "collision direction" vector is less than the x
//            if so, it collided on the left / right
            
//            if not, it collided on top / bottom
            if abs(contact.contactNormal.dy) < abs(contact.contactNormal.dx) {
                onWall = true
                inAir = false
                dashAvailable = true
                if dashing {
                    dashing = false
                    player.physicsBody?.velocity.dx = 0
                }
            }
            
            print(contact.contactNormal)
                inAir = false
                dashAvailable = true
            
        }
        
        if (nodeA.name == "dash-ground" || nodeB.name == "dash-ground") && (nodeA.name == "player" || nodeB.name == "player") {
//            detect if dashing, if so go through
            if !dashing {
                let dashGround = (nodeA.name == "dash-ground" ? nodeA : nodeB)
                
                dashGround.physicsBody?.categoryBitMask = 1
                dashGround.physicsBody?.collisionBitMask = 1
//            detect if the y of the "collision direction" vector is less than the x
//            if so, it collided on the left / right

//            if not, it collided on top / bottom

                if abs(contact.contactNormal.dy) < abs(contact.contactNormal.dx) {
                    onWall = true
                }
                
                inAir = false
                dashAvailable = true
            }
        }
        
        if  (nodeA.name == "coin" || nodeB.name == "coin") && (nodeA.name == "player" || nodeB.name == "player") {
            let coin = (nodeA.name == "coin" ? nodeA : nodeB)
            
            coin.removeFromParent() // destroy the coin
            
            coins += 1
            
            coinLabel.text = "coins: \(coins)"
            
            if AppData.curSave.highScore < coins{
                AppData.curSave.highScore = coins
                AppData.saveData()
//                highScoreLabel.text = "highest score: \(AppData.curSave.highScore)"
            }
            
        }
        
        if  (nodeA.name == "spike" || nodeB.name == "spike") && (nodeA.name == "player" || nodeB.name == "player") {
            let spike = (nodeA.name == "spike" ? nodeA : nodeB)
            
            killPlayer()
        }
        
        
        if (nodeA.name == "dash-spike" || nodeB.name == "dash-spike") && (nodeA.name == "player" || nodeB.name == "player") {
//            detect if dashing, if so go through
            if !dashing {
                let dashGround = (nodeA.name == "dash-spike" ? nodeA : nodeB)
                
                dashGround.physicsBody?.categoryBitMask = 1
                dashGround.physicsBody?.collisionBitMask = 1
                
                killPlayer()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if playerDead {
            return
        }
        
        if contact.bodyA.node == nil || contact.bodyB.node == nil {
            return
        }
        
        let nodeA = contact.bodyA.node!
        let nodeB = contact.bodyB.node!
        
        if (nodeA.name == "dash-spike" || nodeB.name == "dash-spike") && (nodeA.name == "player" || nodeB.name == "player") {
            let dashGround = (nodeA.name == "dash-spike" ? nodeA : nodeB)
            
            dashGround.physicsBody?.categoryBitMask = 0
            dashGround.physicsBody?.collisionBitMask = 0
        }
        
        if (nodeA.name == "ground" || nodeB.name == "ground") && (nodeA.name == "player" || nodeB.name == "player") {
            
//            detect if the y of the "collision direction" vector is less than the x
//            if so, it collided on the left / right
            
//            if not, it collided on top / bottom
            if onWall {
//                goingLeft = !goingLeft
                onWall = false
//                player.physicsBody?.velocity.dx = CGFloat(runSpeed * (goingLeft ? -1 : 1))
            }
        }
        
        if (nodeA.name == "dash-ground" || nodeB.name == "dash-ground") && (nodeA.name == "player" || nodeB.name == "player") {
            let dashGround = (nodeA.name == "dash-ground" ? nodeA : nodeB)
            
            dashGround.physicsBody?.categoryBitMask = 0
            dashGround.physicsBody?.collisionBitMask = 0
            
            if !dashing {
                if onWall {
                    goingLeft = !goingLeft
                    onWall = false
                    player.physicsBody?.velocity.dx = CGFloat(runSpeed * (goingLeft ? -1 : 1))
                }
            }
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if playerDead {
            // BIG BRAIN move here: check if it even exists
            if let dieThing = dieThing{
                dieThing.removeFromParent()
            }
            playerDead = false
            reset()
            
            return
        }
        if (isPaused) {return}// force the function to not happen if the game is paused
        if !inAir {
            player.physicsBody?.velocity.dy = 1000
            inAir = true
            jumping = true
            if onWall {
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
    
    func killPlayer(){
        playerDead = true
        
        viewController.pauseButton.isHidden = true
        
        var background = SKSpriteNode(color: .gray, size: CGSize(width: self.size.width, height: self.size.height))
        
        background.alpha = 0.5
        
        let texty = SKLabelNode(text: "you died lol")
        texty.fontSize = 40
        texty.fontName = "Helvetica Neue Medium"
        
        let texty2 = SKLabelNode(text: "highest score: \(AppData.curSave.highScore)")
        texty2.position.y = texty.position.y - 100
        texty2.fontSize = 40
        texty2.fontName = "Helvetica Neue Medium"
        texty2.fontColor = UIColor.orange
        
        background.addChild(texty)
        background.addChild(texty2)
        
        background.isHidden = false
        
        self.addChild(background)
        
        dieThing = background
    }
    
    func reset(){
//        reset all the goobers
        gamePaused = false
        inAir = false
        goingLeft = false
        dashing = false
        onWall = false
        jumping = false
        playerDead = false
        dashAvailable = true
        
        coins = 0
        coinLabel.text = "coins: \(coins)"
        stage = 1
        stageLabel.text = "stage: 1"
//        highScoreLabel.text = "highest score: \(AppData.curSave.highScore)"
        viewController.pauseButton.isHidden = false
        player.position = CGPoint(x: 0.0, y: 0.0)
        player.physicsBody?.velocity = CGVector(dx: 500, dy: 0)
        player.physicsBody!.friction = 0
        player.zRotation = 0
        player.physicsBody?.allowsRotation = false
    }

    
    override func update(_ currentTime: TimeInterval) {
        
        
        if gamePaused {isPaused = true;return}else{isPaused=false} // force the game to stop if it's actually paused. meant to stop the game from continuing automatically if it's just re-selected again if it's actually paused
        if !playerDead{
            cam.position = player.position
        }
            dieThing?.position = cam.position
        if player.position.y <= -200 && !playerDead{
            killPlayer()
        }
        
        if playerDead {
            return
        }
        
        stageLabel.text = "stage: \(stage)"
        
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
    
    func spawnNextObstacle()
    {
        var obstacle = Obstacle.getRandomObstacle()
        
        var newObstacleNode: SKNode!
        if curObstacles.count == 0 {
            newObstacleNode = obstacle.spawnAsClone(previousNode: initialSpawn)
            curObstacles.append(newObstacleNode)
        } else {
            newObstacleNode = obstacle.spawnAsClone(previousNode: curObstacles[curObstacles.count - 1])
            curObstacles.append(newObstacleNode)
            
            if curObstacles.count > 3 {
                curObstacles.remove(at: 0)
            }
        }
        
        self.addChild(newObstacleNode)
    }
}

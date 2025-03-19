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
    
    let developerMode = false // for testing. if true, death is disabled except for falling off
    
    var player: SKSpriteNode!
    
    var dieThing: SKSpriteNode!
    
    var viewController: GameViewController!
    
    var gamePaused = false
    
    var inAir = false
    
    var goingLeft = false
    
    var dashing = false
    
    var onWall = false
    
    var onFloor = false
    
    var jumping = false
    
    var playerDead = false
    
    var dashAvailable = true
    
    var didDash = false // confusion? ok let me explain then. this will say whether the player HAS dashed before hitting something like the ground or whatever. this is supposed to try to fix the dashing issue
    
    var runSpeed = 400
    
    var coins = 0
    
    var stage = 1
    
    var lastTime = -1.0
    
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
        
        stageLabel = SKLabelNode(text: "stage: \(stage)")
        stageLabel.fontSize = 40
        stageLabel.fontName = "Helvetica Neue Medium"
        stageLabel.position = CGPoint(x: -200, y: 500)
        
        cam.addChild(coinLabel)
        cam.addChild(stageLabel)
        
        player = self.childNode(withName: "player") as! SKSpriteNode
        
        initialSpawn = self.childNode(withName: "firstobstacleposition")
        
        var obstacleNodes = [SKNode]()
        
        for i in 0...5 {
            let nodey = self.childNode(withName: "obstacle\(i)")!
            obstacleNodes.append(nodey)
            nodey.removeFromParent()
        }
        
        
        Obstacle(node: obstacleNodes[0], direction: "vertical", difficulty: 1)
        
        Obstacle(node: obstacleNodes[1], direction: "horizontal", difficulty: 1)
        
        Obstacle(node: obstacleNodes[2], direction: "horizontal", difficulty: 2)
        
        Obstacle(node: obstacleNodes[3], direction: "vertical", difficulty: 2)
        
        Obstacle(node: obstacleNodes[4], direction: "vertical", difficulty: 2)
        
        Obstacle(node: obstacleNodes[5], direction: "vertical", difficulty: 1)
        
        
    }
    var flur = 0
    func didBegin(_ contact: SKPhysicsContact) {
        if playerDead {
            return
        }
        let nodeA = contact.bodyA.node!
        let nodeB = contact.bodyB.node!
        
        if (nodeA.name == "ground" || nodeB.name == "ground") && (nodeA.name == "player" || nodeB.name == "player") {
            
            let ground = (nodeA.name == "ground" ? nodeA : nodeB)
            
            let parenty = ground.parent!
            // immediately set didDash to false because there's no point in it anymore
            didDash = false
            
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
            } else if parenty.convert(ground.position, from: self).y < player.position.y {
                inAir = false
                dashAvailable = true
                onFloor = true
                
                if onWall {
                    goingLeft = !goingLeft
                    onWall = false
                }
                
                player.physicsBody?.velocity.dx = CGFloat(runSpeed * (goingLeft ? -1 : 1))
            } else {
                
            }
            
            
        }
        
        if (nodeA.name == "dash-ground" || nodeB.name == "dash-ground") && (nodeA.name == "player" || nodeB.name == "player") {
//            detect if dashing, if so go through
            if !dashing || !didDash { // adding didDash to check if they did dash before
                let dashGround = (nodeA.name == "dash-ground" ? nodeA : nodeB)
                
                dashGround.physicsBody?.categoryBitMask = 1
                dashGround.physicsBody?.collisionBitMask = 1
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
                } else if dashGround.position.y < player.position.y {
                    inAir = false
                    dashAvailable = true
                    onFloor = true
                    
                    if onWall {
                        goingLeft = !goingLeft
                        onWall = false
                    }
                    
                    player.physicsBody?.velocity.dx = CGFloat(runSpeed * (goingLeft ? -1 : 1))
                } else {
                    
                }
                
            }
        }
        
        if  (nodeA.name == "finish-area" || nodeB.name == "finish-area") && (nodeA.name == "player" || nodeB.name == "player") {
            let finishArea = (nodeA.name == "finish-area" ? nodeA : nodeB)
            
            finishArea.removeFromParent()
            
            if stage > 1
            {
                spawnNextObstacle()
            }
            
            stage += 1
            
            stageLabel.text = "stage: \(stage)"
        }
        
        if  (nodeA.name == "coin" || nodeB.name == "coin") && (nodeA.name == "player" || nodeB.name == "player") {
            let coin = (nodeA.name == "coin" ? nodeA : nodeB) as! SKSpriteNode
            
            // start disappearing code
            let shadow = SKSpriteNode(color: .yellow, size: CGSize(width: coin.size.width, height: coin.size.height))
            
            shadow.zPosition = -1
            shadow.texture = SKTexture(image: UIImage(named: "cheese")!)
            //  i remembered that you told me that it wasn't showing up in the position because it didn't have the same parent as the coin. so i figured, why not just add the shadow thing to the parent of the coin
            coin.parent?.addChild(shadow)
            shadow.position = coin.position
            let shrinkAction = SKAction.resize(toWidth: 0.0, height: 0.0, duration: 0.5)
            
            let completionAction = SKAction.run {
                shadow.removeFromParent()
            }
            
            let sequence = SKAction.sequence([shrinkAction, completionAction])
            
            shadow.run(sequence)
            // end disappearing code
            
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
            
            if !developerMode{
                killPlayer()
            }
        }
        
        
        if (nodeA.name == "dash-spike" || nodeB.name == "dash-spike") && (nodeA.name == "player" || nodeB.name == "player") {
//            detect if dashing, if so go through
            if !dashing || !didDash {
                let dashGround = (nodeA.name == "dash-spike" ? nodeA : nodeB)
                
                dashGround.physicsBody?.categoryBitMask = 1
                dashGround.physicsBody?.collisionBitMask = 1
                
                if !developerMode{
                    killPlayer()
                }
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
                
                if contact.contactNormal.dy < 0.1 {
                    inAir = true
                }
//                player.physicsBody?.velocity.dx = CGFloat(runSpeed * (goingLeft ? -1 : 1))
            }
            
        }
        
        if (nodeA.name == "dash-ground" || nodeB.name == "dash-ground") && (nodeA.name == "player" || nodeB.name == "player") {
            let dashGround = (nodeA.name == "dash-ground" ? nodeA : nodeB)
            
            dashGround.physicsBody?.categoryBitMask = 0
            dashGround.physicsBody?.collisionBitMask = 0
            
            if !dashing {
                if onWall {
    //                goingLeft = !goingLeft
                    onWall = false
                    
                    if contact.contactNormal.dy < 0.1 {
                        inAir = true
                    }
    //                player.physicsBody?.velocity.dx = CGFloat(runSpeed * (goingLeft ? -1 : 1))
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
            player.physicsBody?.velocity.dx = (2500 * (goingLeft ? -1 : 1))
            dashing = true
            didDash = true
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
        
        let texty = SKLabelNode(text: "you died lol 💀")
        texty.fontSize = 60
        texty.fontName = "Helvetica Neue Medium"
        texty.position.y += 150
        
        let texty2 = SKLabelNode(text: "highest score: \(AppData.curSave.highScore)")
        texty2.fontSize = 40
        texty2.fontName = "Helvetica Neue Medium"
        texty2.fontColor = UIColor.orange
        
        let texty3 = SKLabelNode(text: "Tap anywhere to restart")
        texty3.position.y = texty.position.y - 300
        texty3.fontSize = 45
        texty3.fontName = "Helvetica Neue Medium"
        texty3.fontColor = UIColor.green
        
        background.addChild(texty)
        background.addChild(texty2)
        background.addChild(texty3)
        
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
        didDash = false
        onWall = false
        jumping = false
        playerDead = false
        dashAvailable = true
        
        coins = 0
        coinLabel.text = "coins: \(coins)"
        stage = 1
        stageLabel.text = "stage: 1"
        
        for i in curObstacles {
            i.removeFromParent()
        }
        
        curObstacles.removeAll()
        
        viewController.pauseButton.isHidden = false
        player.position = CGPoint(x: 0.0, y: 0.0)
        cam.position = CGPoint(x: 0.0, y: 0.0)
        player.physicsBody?.velocity = CGVector(dx: 500, dy: 0)
        player.physicsBody!.friction = 0
        player.zRotation = 0
        player.physicsBody?.allowsRotation = false
    }

    var dashShadowTimer = 0.1
    
    override func update(_ currentTime: TimeInterval) {
        if lastTime == -1
        {
            lastTime = currentTime
        }
        
        var dt = currentTime - lastTime
        
        
        if gamePaused {isPaused = true;return}else{isPaused=false} // force the game to stop if it's actually paused. meant to stop the game from continuing automatically if it's just re-selected again if it's actually paused
        if !playerDead{
            if cam.position.y + 200 < player.position.y{
                cam.position.y = player.position.y - 200
            }
            cam.position.x = player.position.x
        }
            dieThing?.position = cam.position
        if player.position.y <= (cam.position.y-self.frame.height/2) && !playerDead{
            killPlayer()
        }
        
        if playerDead {
            return
        }
        
        while curObstacles.count < 3 {
            spawnNextObstacle()
        }
        
        stageLabel.text = "stage: \(stage)"
        
        if (player.physicsBody?.velocity.dy)! < 0 {
            jumping = false
        }
        
        if onWall {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: -50)
        }
        
//        print(jumping ? "i jumpy" : "i no jumpy")
        if !jumping {
            player.physicsBody?.velocity.dy -= 20
        }
        
        if dashing {
            player.physicsBody?.velocity.dx -= 100 * (goingLeft ? -1 : 1)
            dashShadowTimer -= dt
            
            if dashShadowTimer < 0 {
                dashShadowTimer = 0.1
                
                var shadow = SKSpriteNode(color: .white, size: CGSize(width: 75, height: 75))
                
                shadow.zPosition = -1
                
                shadow.position = player.position
                
                let fadeOutAction = SKAction.fadeAlpha(to: 0, duration: 0.5)
                
                let completionAction = SKAction.run {
                    shadow.removeFromParent()
                }
                
                let sequence = SKAction.sequence([fadeOutAction, completionAction])
                
                self.addChild(shadow)
                
                shadow.run(sequence)
                
                
            }
            
            if (abs(player.physicsBody?.velocity.dx as! CGFloat)) < CGFloat(runSpeed) {
                dashing = false
                dashShadowTimer = 0.1
            }
        }
        
        lastTime = currentTime
    }
    
    func spawnNextObstacle()
    {
        var obstacle : Obstacle!
        if stage < 3{
            obstacle = Obstacle.getRandomObstacleOnlyDifficulty(difficulty: 1)
        }else if stage == 3{
            obstacle = Obstacle.getRandomObstacleOnlyDifficulty(difficulty: 2)
        }else{
            obstacle = Obstacle.getRandomObstacleWithinDifficulty(difficulty: 2)
        }
        var newObstacleNode: SKNode!
        if curObstacles.count == 0 {
            newObstacleNode = obstacle.spawnAsClone(previousNode: initialSpawn)
            curObstacles.append(newObstacleNode)
        } else {
            newObstacleNode = obstacle.spawnAsClone(previousNode: curObstacles[curObstacles.count - 1])
            curObstacles.append(newObstacleNode)
            
            if curObstacles.count > 3 {
                curObstacles.remove(at: 0).removeFromParent()
            }
        }
        
        self.addChild(newObstacleNode)
    }
}

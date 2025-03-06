//
//  Obstacle.swift
//  foreverGameCLCApp
//
//  Created by DANIEL HUSEBY on 3/5/25.
//

import Foundation
import SpriteKit

class Obstacle{
    static var allObstacles = [Obstacle]()
    
    // matthew if you're reading this, i am gonna use this to name the obstacles. i was thinking maybe a tutorial obstacle?
    // i am gonna also insert a function that would return the obstacle by direct name down in the static functions
    var node: SKNode
    var direction: String
    var difficulty: String
    
    init(node: SKNode, direction: String, difficulty: String) {
        self.node = node
        self.direction = direction
        self.difficulty = difficulty
        Obstacle.allObstacles.append(self)
    }
    
    // All of these random node methods require there to be an obstacle in the first place inside of the allObstacles array
    // and the one that uses difficulty requires at least 1 obstacle with that difficulty
    
    // all of this code is commented out because i am going to wait until later to see how we should implement this
    
    static func getRandomObstacleDifficulty(difficulty: String) -> Obstacle{
        var hi = [Obstacle]()
        for i in allObstacles{
            if (i.difficulty==difficulty) {hi.append(i)};
        }
        return hi[Int.random(in: 0..<hi.count)]
    }
    
    static func getRandomObstacle() -> Obstacle{
        allObstacles[Int.random(in: 0..<allObstacles.count)]
    }
    
    
    
    
}

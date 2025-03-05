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
    
    var node: SKNode
    var direction: String
    var difficulty: String
    
    init(node: SKNode, direction: String, difficulty: String) {
        self.node = node
        self.direction = direction
        self.difficulty = difficulty
        Obstacle.allObstacles.append(self)
    }
    
    // Both of these random node methods require there to be an obstacle in the first place inside of the allObstacles array
    // and the one that uses difficulty requires at least 1 obstacle with that difficulty
    
//    static func getRandomNodeDifficulty(difficulty: String) -> Obstacle{
//
//    }
    
    static func getRandomNode() -> Obstacle{
        return allObstacles[Int.random(in: 0..<allObstacles.count)]
    }
    
    
    
    
}

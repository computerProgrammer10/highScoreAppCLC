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
    var end: [String:String]
    var start: [String:String]
    
    
    init(node: SKNode, end: [String : String], start: [String : String]) {
        self.node = node
        self.end = end
        self.start = start
        Obstacle.allObstacles.append(self)
    }
    
    func getClone() -> SKNode{
        return node.copy() as! SKNode
    }
    
    func checkStart(){
        
    }
    
    private func getOpposite(topBot: String, leftRight: String) -> [String:String]{
        var huh = ""
        var huh2 = ""
        if topBot == "top"{
            huh = "bot"
        }else{
            huh = "top"
        }
        if leftRight == "right"{
            huh2 = "left"
        }else{
            huh2 = "right"
        }
        return [huh:huh2]
    }
    
    
    
    static func getRandomNode() -> Obstacle{
        return allObstacles[Int.random(in: 0..<allObstacles.count)]
    }
    
    
    
    
}

//
//  Save.swift
//  foreverGameCLCApp
//
//  Created by DANIEL HUSEBY on 2/28/25.
//

import Foundation

class Save: Codable{
    var highScore: Int
    var coins: Int
    var username: String
    var skins: [String]
    init(highScore: Int, coins: Int, username: String, skins: [String]) {
        self.highScore = highScore
        self.coins = coins
        self.username = username
        self.skins = skins
    }
    init() {
        self.highScore = 0
        self.coins = 0
        self.username = "Default"
        self.skins = [String]()
    }
}

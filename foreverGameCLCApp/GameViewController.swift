//
//  GameViewController.swift
//  foreverGameCLCApp
//
//  Created by DANIEL HUSEBY on 2/25/25.
// change

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var play: GameScene!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.portrait.rawValue
                    UIDevice.current.setValue(value, forKey: "orientation")
        
        if let view = self.view as! SKView? {
            
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                play = scene as! GameScene
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    
    @IBAction func pauseAction(_ sender: Any) {
        if !play.gamePaused{
            pauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            play.isPaused = true
            play.gamePaused = true
            
        }else{
            pauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            play.isPaused = false
            play.gamePaused = false
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

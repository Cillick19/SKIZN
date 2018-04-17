//
//  GameViewController.swift
//  Skizn
//
//  Created by Cyrus Illick on 12/19/17.
//  Copyright © 2017 cyrusIllick. All rights reserved.
//


//most of this code is already given to you just by creating the xcode project
import UIKit
import SpriteKit
import GameplayKit
import GameKit


class GameViewController: UIViewController, GKGameCenterControllerDelegate {


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    authPlayer()
       // saveHighscore(number: score)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = StartGameScene(size: CGSize(width: 1536, height: 2048))
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
            

        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }


    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

   
}



//
//  GameOverScene.swift
//  Skizn
//
//  Created by Cyrus Illick on 12/21/17.
//  Copyright © 2017 cyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit
import StoreKit
import UIKit
import GameKit




class GameOverScene: SKScene {
    
    
    
    
    let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
    let leaderBoard = SKLabelNode(fontNamed: "The Bold Font")
    let purchase = SKLabelNode(fontNamed: "The Bold Font")
    
    
    var purchaseButton: SKNode! = nil
    var ledBoardButton: SKNode! = nil
    var resButton: SKNode! = nil
    var extraButton: SKNode! = nil
    
 
    
    
    override func didMove(to view: SKView) {
        
          IAPService.shared.getProducts()
        
        let background = SKSpriteNode(imageNamed: "BackgroundSnow")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.83 )
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.7)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber {
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
            
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.black
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.6)
        self.addChild(highScoreLabel)
        
        let extraPointsLabel = SKLabelNode(fontNamed: "The Bold Font")
        extraPointsLabel.text = "500 extra points"
        extraPointsLabel.fontSize = 90
        extraPointsLabel.fontColor = SKColor.black
        extraPointsLabel.zPosition = 1
        extraPointsLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.48)
        self.addChild(extraPointsLabel)
        
        
        let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
        restartLabel.text = "Tap To Restart"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.black
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.3)
        self.addChild(restartLabel)
        
        let leaderBoard = SKLabelNode(fontNamed: "The Bold Font")
        leaderBoard.text = "Leaderboard"
        leaderBoard.fontSize = 90
        leaderBoard.fontColor = SKColor.black
        leaderBoard.zPosition = 1
        leaderBoard.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.08)
        self.addChild(leaderBoard)
        
        
        let purchase = SKLabelNode(fontNamed: "The Bold Font")
        purchase.text = "Donate"
        purchase.fontSize = 90
        purchase.fontColor = SKColor.black
        purchase.zPosition = 1
        purchase.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.18)
        self.addChild(purchase)
        
        restartButton()
        
        leaderBoardButton()
        
        StoreButton()
        
        PointsButton()
    }
    
    

    
    
    func restartButton() {
        resButton = SKSpriteNode(color: SKColor.red, size: CGSize(width: 1000, height: 200))
        // Put it in the center of the scene
        resButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.3);
        
        self.addChild(resButton)
        
        
    }
    
    func leaderBoardButton() {
        ledBoardButton = SKSpriteNode(color: SKColor.red, size: CGSize(width: 1000, height: 150))
        // Put it in the center of the scene
        ledBoardButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.08);
        
        self.addChild(ledBoardButton)
        
        
    }
    
    func StoreButton() {
        purchaseButton = SKSpriteNode(color: SKColor.red, size: CGSize(width: 1000, height: 150))
        purchaseButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.18);
        
        self.addChild(purchaseButton)
        
    }
    
    func PointsButton() {
        extraButton = SKSpriteNode(color: SKColor.red, size: CGSize(width: 1000, height: 200))
        extraButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.48)
        self.addChild(extraButton)
    }
    
//    func saveHighscore(number : Int) {
//        if GKLocalPlayer.localPlayer().isAuthenticated {
//
//            let scoreReporter = GKScore(leaderboardIdentifier: "leaderboard")
//
//            scoreReporter.value = Int64(number)
//
//            let scoreArray : [GKScore] = [scoreReporter]
//
//            GKScore.report(scoreArray, withCompletionHandler: nil)
//
//
//        }
//    }
//
    
    

    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        // Check if the location of the touch is within the button's bounds
        if resButton.contains(touchLocation) {
            print("tapped!")
            
            let sceneToMoveTo = GameScene(size: self.size)
            sceneToMoveTo.scaleMode = self.scaleMode
            let myTransition = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            
            
        }
        if purchaseButton.contains(touchLocation) {
            print("tapped!")
            
            let sceneToMoveTo = StoreScene(size: self.size)
            sceneToMoveTo.scaleMode = self.scaleMode
            let myTransition = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            
            
        }
        if ledBoardButton.contains(touchLocation) {
            print("tapped!")
            
   //         saveHighscore(number: gameScore)
            
            
        
            
            //...
//            let MenuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
//            self.present(MenuVC, animated: true, completion: nil)
            
           // let newViewController = NewViewController()
           // self.navigationController?.pushViewController(newViewController, animated: true)
           // showLeaderBoard()
            
            if let url = URL(string: "https://sites.google.com/hopkins.edu/skizn-leaderboard/home") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }
        if extraButton.contains(touchLocation) {
            print("You are going to buy something")
            IAPService.shared.purchase(product: .consumable)
            gameScore += 500

            
        }

        
        
    }
    
    
}

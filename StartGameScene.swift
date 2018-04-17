//
//  StartGameScene.swift
//  Skizn
//
//  Created by Cyrus Illick on 12/21/17.
//  Copyright © 2017 cyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit

class StartGameScene: SKScene {
    
    let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    var resButton: SKNode! = nil
    
    
    
    override func didMove(to view: SKView) {
        
        
        
        let background = SKSpriteNode(imageNamed: "BackgroundSnow")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "Skizn"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.8 )
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel.text = "Ski Season"
        scoreLabel.fontSize = 100
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
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.55)
        self.addChild(highScoreLabel)
        
        
        let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
        restartLabel.text = "Tap To Start"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.black
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.4)
        self.addChild(restartLabel)
        
        let explanationLabel = SKLabelNode(fontNamed: "The Bold Font")
        explanationLabel.text = "Avoid the green trees"
        explanationLabel.fontSize = 55
        explanationLabel.fontColor = SKColor.black
        explanationLabel.zPosition = 1
        explanationLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.23)
        self.addChild(explanationLabel)
        
        let explanationLabel2 = SKLabelNode(fontNamed: "The Bold Font")
        explanationLabel2.text = "Stay alive to earn points"
        explanationLabel2.fontSize = 55
        explanationLabel2.fontColor = SKColor.black
        explanationLabel2.zPosition = 1
        explanationLabel2.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.18)
        self.addChild(explanationLabel2)
        
        restartButton()
        
        
    }
    
    func restartButton() {
        resButton = SKSpriteNode(color: SKColor.red, size: CGSize(width: 1000, height: 300))
        // Put it in the center of the scene
        resButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.4);
        
        self.addChild(resButton)
        
        
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
    }
    

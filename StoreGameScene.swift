//
//  StartStoreScene.swift
//  Skizn
//
//  Created by Cyrus Illick on 12/21/17.
//  Copyright © 2017 cyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import StoreKit


var payedForCharacter = false

//var sharedSecret = "498bc9c0517f42cd80467c791a981373"

class StoreScene: SKScene {
    
  //  var Money : Int!
    
    
    var BuyButton: SKNode! = nil
    var snowGuyButton: SKNode! = nil
    var BackButton: SKNode! = nil
    
    
    override func didMove(to view: SKView) {
        
        
        IAPService.shared.getProducts()
        
        let background = SKSpriteNode(imageNamed: "BackgroundSnow")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let purchase = SKLabelNode(fontNamed: "The Bold Font")
        purchase.text = "The app is free please donate"
        purchase.fontSize = 73
        purchase.fontColor = SKColor.black
        purchase.zPosition = 1
        purchase.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.22)
        self.addChild(purchase)
        
        let storeLabel = SKLabelNode(fontNamed: "The Bold Font")
        storeLabel.text = "Donations"
        storeLabel.fontSize = 150
        storeLabel.fontColor = SKColor.black
        storeLabel.zPosition = 1
        storeLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.6)
        self.addChild(storeLabel)
        
        let homeLabel = SKLabelNode(fontNamed: "The Bold Font")
        homeLabel.text = "Home"
        homeLabel.fontSize = 90
        homeLabel.fontColor = SKColor.black
        homeLabel.zPosition = 1
        homeLabel.position = CGPoint(x: self.size.height * 0.2, y: self.size.height * 0.08)
        self.addChild(homeLabel)
        
        
        let snowboarderLabel = SKLabelNode(fontNamed: "The Bold Font")
        snowboarderLabel.text = "DONATE"
        snowboarderLabel.fontSize = 60
        snowboarderLabel.fontColor = SKColor.black
        snowboarderLabel.zPosition = 1
        snowboarderLabel.position = CGPoint(x: self.size.height * 0.4, y: self.size.height * 0.5)
        self.addChild(snowboarderLabel)
        
//        if payedForCharacter == true {
//            let bought = SKLabelNode(fontNamed: "The Bold Font")
//            bought.text = "Bought"
//            bought.fontSize = 40
//            bought.fontColor = SKColor.red
//            bought.zPosition = 1
//            bought.position = CGPoint(x: self.size.height * 0.5, y: self.size.height * 0.4)
//            self.addChild(bought)
//        }
        
        
        
        HomeButton()
        
        
        PurchaseButton()
        
        snowboarderButton()
        
    }
    
    
    func PurchaseButton() {
        BuyButton = SKSpriteNode(color: SKColor.red, size: CGSize(width: 1000, height: 500))
        BuyButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.22);
        
        self.addChild(BuyButton)
        
    }
    
    func HomeButton() {
        BackButton = SKSpriteNode(color: SKColor.red, size: CGSize(width: 400, height: 200))
        BackButton.position = CGPoint(x: self.size.height * 0.2, y: self.size.height * 0.08);
        
        self.addChild(BackButton)
        
    }
    
    func snowboarderButton() {
        snowGuyButton = SKSpriteNode(color: SKColor.red, size: CGSize(width: 400, height: 200))
        snowGuyButton.position = CGPoint(x: self.size.height * 0.5, y: self.size.height * 0.5);
        
        self.addChild(snowGuyButton)
        
    }
    
    func boughtfunc() {
        let bought = SKLabelNode(fontNamed: "The Bold Font")
        bought.text = "Thanks"
        bought.fontSize = 40
        bought.fontColor = SKColor.red
        bought.zPosition = 1
        bought.position = CGPoint(x: self.size.height * 0.5, y: self.size.height * 0.4)
        self.addChild(bought)
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        // Check if the location of the touch is within the button's bounds
        if BuyButton.contains(touchLocation) {
            print("You Just Bought Something")
           // IAPService.shared.purchase(product: .consumable)
            
            
            
        }
        
        if BackButton.contains(touchLocation) {
            print("Going to first Screen")
            let sceneToMoveTo = StartGameScene(size: self.size)
            sceneToMoveTo.scaleMode = self.scaleMode
            let myTransition = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            
            
        }
        if snowGuyButton.contains(touchLocation) {
                print("Donaterd")
                payedForCharacter = true
            IAPService.shared.purchase(product: .consumable1)
            if payedForCharacter == true {
                boughtfunc()
            }
            
        }
    }
    
    
    

    
}

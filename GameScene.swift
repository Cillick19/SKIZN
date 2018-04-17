//
//  GameScene.swift
//  SpaceGame
//
//  Created by Cyrus Illick on 12/8/17.
//  Copyright © 2017 cyrusIllick. All rights reserved.
//

/*
    SKIZN or Ski SZN is a skiing game.
    The character can move back and forth across the screen and has to avoid the trees.
    there are other skiers and snowboarders on the mountain, but the player can't run into them,
    they are there to help.
    the objective is to stay alive as long as possible, so as long as the player is alive the
    player is gaining points
    I learned how to code swift ios games by watching many youtube videos, Matt Heany Apps was a very well made and helpful youtube channel.
 
 */

//these are the "kits" that are used in this game
//they contain functions that make the game easier to code
import UIKit
import SpriteKit
import GameplayKit

//Define the gamescore outside of all functions because it is used in pre and post game scenes as well
//game score is reset back to zero after player looses
var gameScore = 0



class GameScene: SKScene, SKPhysicsContactDelegate {    
    
    var gameArea: CGRect
    
    //these are booleans that are used in the direction that the player is pointing and are used in the change direction and touches began function
    var check = false
    var direction = false
    
    
    var n = 25
    
    /*these numbers are assigned to each of the objects in this game so when they come into
    contact with eachother the function "did begin contact"
    will know which object is which and run what is suppoed to happen
    */
    var None: UInt32 = 0
    var Player: UInt32 = 1
    var Tree: UInt32 = 2
    var WallRight: UInt32 = 4
    var WallLeft: UInt32 = 4
    var ActualWallRight: UInt32 = 4
    var ActualWallLeft: UInt32 = 4
    var ScoreLine: UInt32 = 6
    var OtherSkier: UInt32 = 12
    var OtherSnowboarder: UInt32 = 20
    
    
    //each label needs to be defined and given the font that I have imported into xcode
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    

    let livesLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    //the player starts with 3 lives
    var livesNumber = 3
    
    //the levels are not desplayed on screen, but as the score reaches certain numbers the amount of spawing trees increase
    var levelNumber = 0
    
    let TapToStartLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    //touches began function does different things depending on weather the game is in pregame or ingame state
    //when the game goes into aftergame everything stops and the app switches to the game over scene
    enum gameState {
        case preGame //before the start of the game
        case inGame //when the game is happening
        case afterGame //after the game
    }
    
    //even though this is the game scene, the user still has to tap to start to turn the game into the ingame state
    var currentGameState = gameState.preGame
    
    
    //player is a global variable because it is used in a lot of functions
    let player = SKSpriteNode(imageNamed: "TreeDrawing1")

    
    
    override init(size: CGSize) {
        //defines the size of the screen so the app can fit many different sizes of screens
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    //error handler
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

 

    override func didMove(to view: SKView) {

        //sets the gamescore back to zero so the player does not have anypoints when the game starts
        gameScore = 0
        
        //this defines the physics world, which becomes important when objects come into contact with eachother
        self.physicsWorld.contactDelegate = self

        //this is the backgorund, it is in a for loop because the background will be moving down the screen and replaced by another backgorund
        //so it looks like the player is moving down the mountain
        for i in 0...1 {
            
            let background = SKSpriteNode(imageNamed: "BackgroundSnow")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2,
                                          y: self.size.height * CGFloat(i))
            background.zPosition = 0
            background.name = "Background"
            self.addChild(background)
            
        }

        
        //each object basically gets a little paragraph defining all of its characteristics
        //this is defining all of the players characteristics
        player.setScale(0.28)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 38, height: 150))
        player.physicsBody?.affectedByGravity = false
        player.physicsBody!.categoryBitMask =  1
        player.physicsBody!.collisionBitMask = 0
        player.physicsBody!.contactTestBitMask = 2
        self.addChild(player)
        
        //the labels do not interact with anything else on the screen, they are just there to show the user what his or her score is
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.black
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.96)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.black
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width * 0.85 ,y: self.size.height * 0.96)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        TapToStartLabel.text = "Tap To Start"
        TapToStartLabel.fontSize = 100
        TapToStartLabel.fontColor = SKColor.black
        TapToStartLabel.zPosition = 1
        TapToStartLabel.position = CGPoint(x: self.size.height * 0.37, y: self.size.height/2)
        TapToStartLabel.alpha = 1
        self.addChild(TapToStartLabel)
        
        startNewLevel()
        

    }
    
    //this function gets all of the parts of the game to start moving and turns the state from pregame to ingame
    func startGame() {
        
        currentGameState = gameState.inGame
        
        //animation to make it look good
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        TapToStartLabel.run(deleteSequence)
        
        //animation to make it look good
        let moveShipOntoScreenAction = SKAction.moveTo(y: self.size.height * 0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOntoScreenAction, startLevelAction])
        player.run(startGameSequence)
        
    }
    

    //player looses a life if the player hits a tree
    //the player looses all there lives if they go to far off the screen
    func loseALife() {
        
        livesNumber -= 1
        
        /*
         this if else looks unimportant, but if it is not here then when the player goes of screen
        it makes it so the lives number says a negative number before the scene goes to the game over scene,
        so this is just here so that does not happen
         */
        
        if livesNumber > 0 {
        livesLabel.text = "Lives: \(livesNumber)"
        
        } else  {
            livesLabel.text = "Lives: 0"
        }
    
        
        //animation makes it more clear the lives amount changes
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
        
        if livesNumber == 0{
            runGameOver()
        }
        
    }
    
    //player gets points just by surviving, there score is counted by a score counter that is of screen
    func addScore() {
    
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        
        //the game gets increasingly harder when the player gets to theses specific scores
        if gameScore == 200 || gameScore == 700 || gameScore == 1250 || gameScore == 1700 || gameScore == 2300 || gameScore == 3000 || gameScore == 3500 || gameScore == 4000 {
            startNewLevel()
        }
        
    }
    
    func runGameOver() {
        
        currentGameState = gameState.afterGame
        

        //stops the movement of the wall, which is a lot of little objects moving down the screen to catch the player if the player moves off screen
        self.enumerateChildNodes(withName: "WallSectionRight") {
            wallSectionRight, stop in
            
            wallSectionRight.removeAllActions()
            
        }
        
        self.enumerateChildNodes(withName: "WallSectionLeft") {
            wallSectionLeft, stop in
            
            wallSectionLeft.removeAllActions()
            
        }
        

        
      
        //waits a second so the player sees why they lost and so it looks good
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 0.5)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
        
        
    }
    
    
    func changeScene(){
        //moves to the gameoverscene with a little animation to make it look good
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
        
    }
    
    
    
    
    //this is used to make the background move at a speed that looks like the player is skiing down the mountain
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 525.0
    
    
    
    override func update(_ currentTime: TimeInterval) {
        //player gets points everytime the current time updates
        addScore()
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "Background") {
            background, stop in
            
            background.position.y -= amountToMoveBackground
            
            if background.position.y < -self.size.height {
                background.position.y += self.size.height * 2
            }
            
            
            
        }
        
        
    }

    
    func startNewLevel() {
        
        //goes to the next level
        levelNumber += 1
        
        //checks the existance of some local variables from some other functions
        if self.action(forKey: "spawningEnemies") != nil {
            self.removeAction(forKey: "spawningEnemies")
        }
        if self.action(forKey: "spawningTrees") != nil {
            self.removeAction(forKey: "spawningrTrees")
        }
        if self.action(forKey: "spawningWalls") != nil {
            self.removeAction(forKey: "spawningrWalls")
        }
        if self.action(forKey: "spawningSkiDudes") != nil {
            self.removeAction(forKey: "spawningSkiDudes")
        }
        if self.action(forKey: "spawningSnowBoardDudes") != nil {
            self.removeAction(forKey: "spawningSnowBoardDudes")
        }
        
        var levelDuration = TimeInterval()
        
        //these casses define how many of each objsect should be around for each level
        //speed of trees spawning
        switch levelNumber {
        case 1: levelDuration = 1
        case 2: levelDuration = 0.8
        case 3: levelDuration = 0.6
        case 4: levelDuration = 0.3
        case 5: levelDuration = 0.18
        case 6: levelDuration = 0.16
        case 7: levelDuration = 0.15
        default:
            levelDuration = 0.13
            print("Cannot find level info")
            
        }
        
        
        var levelDuration2 = TimeInterval()

        //speed of other skiier spawning
        switch levelNumber {
        case 1: levelDuration2 = 10
        case 2: levelDuration2 = 5
        case 3: levelDuration2 = 4.5
        case 4: levelDuration2 = 3.5
        case 5: levelDuration2 = 3
        case 6: levelDuration2 = 2.9
        case 7: levelDuration2 = 2.8
        default:
            levelDuration2 = 2.8
            print("Cannot find level info")

        }
        
        var levelDuration3 = TimeInterval()
        
        //speed of snowboard spawning
            switch levelNumber {
            case 1: levelDuration3 = 8
            case 2: levelDuration3 = 6
            case 3: levelDuration3 = 4
            case 4: levelDuration3 = 5
            case 5: levelDuration3 = 3.5
            case 6: levelDuration3 = 3
            case 7: levelDuration3 = 2.9
            case 8: levelDuration3 = 2.7
            
        default:
            levelDuration3 = 2.8
            print("Cannot find level info")
            
        }
        
        
        //dealing with the spawning of all of the different objects
        let spawn = SKAction.run(SkiTrack)
        let waitToSpawn = SKAction.wait(forDuration: 0.001)
        let spawnSequence = SKAction.sequence([ spawn, waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
        
        let spawnTree = SKAction.run(spawnTrees)
        let waitToSpawnTree = SKAction.wait(forDuration: levelDuration)
        let spawnTreeSequence = SKAction.sequence([spawnTree, waitToSpawnTree])
        let spawnTreesForever = SKAction.repeatForever(spawnTreeSequence)
        self.run(spawnTreesForever, withKey: "spawningTrees")
        
        let spawnWall = SKAction.run(makeWall)
        let waitToSpawnWalls = SKAction.wait(forDuration: 0.09)
        let spawnWallSequence = SKAction.sequence([spawnWall, waitToSpawnWalls])
        let spawnWallsForever = SKAction.repeatForever(spawnWallSequence)
        self.run(spawnWallsForever, withKey: "spawningWalls")
        
        let spawnOtherSkiers = SKAction.run(skiDude)
        let waitToSpawnSkiDude = SKAction.wait(forDuration: levelDuration2)
        let spawnSkiDudeSequence = SKAction.sequence([waitToSpawnSkiDude, spawnOtherSkiers])
        let spawnSkiDudeForever = SKAction.repeatForever(spawnSkiDudeSequence)
        self.run(spawnSkiDudeForever, withKey: "spawningSkiDudes")
        
        let spawnOtherSnowBoarders = SKAction.run(snowBoardDude)
        let waitToSpawnSnowBoardDude = SKAction.wait(forDuration: levelDuration3)
        let spawnSnowBoardDudeSequence = SKAction.sequence([waitToSpawnSnowBoardDude, spawnOtherSnowBoarders])
        let spawnSnowBoardDudeForever = SKAction.repeatForever(spawnSnowBoardDudeSequence)
        self.run(spawnSnowBoardDudeForever, withKey: "spawningSnowBoardDudes")
        
        
    }
    
    
    
    //function that responds to two objects cominginto contact with eachother
    //I learned about how to write a function like this from the youtuber Matt Heaney Apps
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        //assigns a variable to each object
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
            
        }
        else {
            body1  = contact.bodyB
            body2 = contact.bodyA
        }
        
        //Player hits tree
        if body1.categoryBitMask == 1 && body2.categoryBitMask == 2 {
        
            loseALife()
            if livesNumber > 0 {
                
            deadTree(spawnPosition: body2.node!.position)
                
            }
            if livesNumber <= 0 {
            deadGuy(spawnPosition: body2.node!.position)
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            }
            
            body2.node?.removeFromParent()
          

        }
        
        //Player goes too far off screen and hits the wall
        if body1.categoryBitMask == 1 && body2.categoryBitMask == 4 {
            
            loseALife()
            
        }
        
        //If the player hits the score line it is too far off map and looses a life
        if body1.categoryBitMask == 4 && body2.categoryBitMask == 6 {
           
            loseALife()
            
        }
        
        //When one of the other skiiers hits a tree
        if body1.categoryBitMask == 2 && body2.categoryBitMask == 12 {
            
            body1.node?.removeFromParent()
            moveTree(spawnPosition: body2.node!.position)
            
        }
        
        //If a snowboarder hits a tree
        if body1.categoryBitMask == 2 && body2.categoryBitMask == 20 {
            body1.node?.removeFromParent()
            moveTree(spawnPosition: body2.node!.position)
            
            
        }
        
        // if a skiier hits a snowboarder
        if body1.categoryBitMask == 12 && body2.categoryBitMask == 20 {
      
            spawnExplosion(spawnPosition: body2.node!.position)
            
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
        
        
   
        
      
    }
    

    //function tha spawns an explosion when it is called
    //used for when skiier and snowboarder run into eachother
    func spawnExplosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosition")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        //animation so it looks good
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([scaleIn, fadeOut, delete])
        
        explosion.run(explosionSequence)
        
    }
    
    
    //after tree has been hit, now it is a fallen over tree that is moving down the screen
    func moveTree(spawnPosition: CGPoint) {
        let movedTree = SKSpriteNode(imageNamed: "deadTree")
        movedTree.position = spawnPosition
        movedTree.zPosition = 1
        movedTree.setScale(0.6)
        self.addChild(movedTree)
        

        let movePoint = CGPoint(x: spawnPosition.x, y: spawnPosition.y - 700)
        
        //animation so it looks good
        let moveTree = SKAction.move(to: movePoint, duration: 1.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let deleteTree = SKAction.removeFromParent()
        let TreeSequence = SKAction.sequence([moveTree, fadeOut, deleteTree])
        movedTree.run(TreeSequence)
        
    }
    
    
    //If the player has zero lives the dead guy spawns for a moment before the scene moves to gameOver
    func deadGuy(spawnPosition: CGPoint){
        let deadGuy = SKSpriteNode(imageNamed: "deadGuy")
        deadGuy.position = spawnPosition
        deadGuy.zPosition = 3
        deadGuy.setScale(0.5)
        self.addChild(deadGuy)

        
        let moveDeadGuy = SKAction.moveTo(y: self.size.height * (-0.5), duration: 2.3)

        let delete = SKAction.removeFromParent()
        
        let deadGuySequence = SKAction.sequence([moveDeadGuy, delete])
        
        deadGuy.run(deadGuySequence)
        

    }
    
    //when player hits the tree
    func deadTree(spawnPosition: CGPoint){
        let deadTree = SKSpriteNode(imageNamed: "deadTree")
        deadTree.position = spawnPosition
        deadTree.zPosition = 3
        deadTree.setScale(0.6)
        self.addChild(deadTree)
        
    
        let moveDeadTree = SKAction.moveTo(y: self.size.height * (-0.5), duration: 2.5)

        let delete = SKAction.removeFromParent()
        
        let deadTreeSequence = SKAction.sequence([moveDeadTree, delete])
        
        deadTree.run(deadTreeSequence)
        
    }
    
    
    
    
    //The snowboarddude comes from the side of the screen and helps out the player by making it so more trees are removed
    //it also makes the game look better
    func snowBoardDude() {
        
        
        //the movement of the snowbarders is relatively randome
        let n2 =  CGFloat((arc4random_uniform(6)))
        let r = CGFloat((n2 + 4.0) * 0.1)
        
        let n3 =  CGFloat((arc4random_uniform(6)))
        let r2 = CGFloat((n3 + 8.0) * 0.1)
        
        let startPoint1 = CGPoint(x: self.size.width * 1.1, y: self.size.height * r)
        
        
        let movePoint = CGPoint(x: self.size.width * -0.2 , y: self.size.height * r2)
        
        let endPoint = CGPoint(x: self.size.width * -(r) , y: self.size.height * 2)
        
        
        
        
        let snowBoardDude = SKSpriteNode(imageNamed: "SnowboardGuy")
        snowBoardDude.name = "SkiDude"
        snowBoardDude.setScale(0.3)
        snowBoardDude.position = startPoint1
        snowBoardDude.zPosition = 1
        snowBoardDude.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 150))
        snowBoardDude.physicsBody!.affectedByGravity = false
        snowBoardDude.physicsBody!.categoryBitMask = OtherSnowboarder
        snowBoardDude.physicsBody!.collisionBitMask = 0
        snowBoardDude.physicsBody!.contactTestBitMask = Tree | OtherSkier
        self.addChild(snowBoardDude)
        
        
        
        
        //Trig that rotates the player so the player is pointing at where it is going
        let dx = endPoint.x - startPoint1.x
        let dy =  endPoint.y - startPoint1.y
        let amountToRotate = atan2(dy, dx)
        snowBoardDude.zRotation = amountToRotate
        
        let movePlayer = SKAction.move(to: movePoint, duration: 6)
        let deletePlayer = SKAction.removeFromParent()
        let snowBoardDudeSequence = SKAction.sequence([movePlayer, deletePlayer])
        snowBoardDude.run(snowBoardDudeSequence)
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    //similar to the snowboarddude except it enters the screen from the other side
    func skiDude() {


        //random numbers because the skiiers move randomly
        let n2 =  CGFloat((arc4random_uniform(6)))
        let r = CGFloat((n2 + 4.0) * 0.1)

        let n3 =  CGFloat((arc4random_uniform(6)))
        let r2 = CGFloat((n3 + 8.0) * 0.1)

        let startPoint1 = CGPoint(x: self.size.width * -0.1, y: self.size.height * r)


        let movePoint = CGPoint(x: self.size.width * 1.2 , y: self.size.height * r2)

       let endPoint = CGPoint(x: self.size.width * (r) , y: self.size.height * 2)




        let skiDude = SKSpriteNode(imageNamed: "OtherSkier")
        skiDude.name = "SkiDude"
        skiDude.setScale(0.3)
        skiDude.position = startPoint1
        skiDude.zPosition = 1
        skiDude.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 150))
        skiDude.physicsBody!.affectedByGravity = false
        skiDude.physicsBody!.categoryBitMask = OtherSkier
        skiDude.physicsBody!.collisionBitMask = 0
        skiDude.physicsBody!.contactTestBitMask = Tree
        self.addChild(skiDude)




        //trig for rotation
        let dx = endPoint.x - startPoint1.x
        let dy =  endPoint.y - startPoint1.y
        let amountToRotate = atan2(dy, dx)
        skiDude.zRotation = amountToRotate

        let movePlayer = SKAction.move(to: movePoint, duration: 6)
        let deletePlayer = SKAction.removeFromParent()
        let skiDudeSequence = SKAction.sequence([movePlayer, deletePlayer])
        skiDude.run(skiDudeSequence)



    }
    
    //when the user taps the screen the player switches directions and rotates to point that way
    func changeDirection() {
    

        //boolean to show which direction the player is going
        if direction == false {
            
            let startPoint1 = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.2)
            
          
            let endPoint = CGPoint(x: self.size.width * 1.2 , y: self.size.height * 0.8)
            
            let movePoint = CGPoint(x: self.size.width * 10 , y: self.size.height * 0.25)
            
            let dx = endPoint.x - startPoint1.x
            let dy =  endPoint.y - startPoint1.y
            let amountToRotate = atan2(dy, dx)
            player.zRotation = amountToRotate
            
            let movePlayer = SKAction.move(to: movePoint, duration: 20)
            player.run(movePlayer)
            
            check = true
            
            
        }
        if direction == true {
            
           
            
            let startPoint2 = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.2)
            
         
            let endPoint2 = CGPoint(x: self.size.width * (-0.2) , y: self.size.height * 0.8)
            
            let movePoint = CGPoint(x: self.size.width * (-10) , y: self.size.height * 0.25)
            
            let dx2 = endPoint2.x - startPoint2.x
            let dy2 =  endPoint2.y - startPoint2.y
            let amountToRotate2 = atan2(dy2, dx2)
            player.zRotation = amountToRotate2
            
            let movePlayer = SKAction.move(to: movePoint, duration: 20)
            player.run(movePlayer)
            
            
            check = false
            
            
        }
        
}

    //this function just makes the game look better
    func SkiTrack() {
        let skiTrack = SKSpriteNode(imageNamed: "greyDot")
        skiTrack.setScale(0.2)
        skiTrack.position = CGPoint(x: player.position.x, y: player.position.y)
    
        skiTrack.zPosition = 1
        
        self.addChild(skiTrack)
        
        
        let endPoint = CGPoint(x: player.position.x, y: player.position.y * (-0.2))
        let moveDot = SKAction.move(to: endPoint, duration: 1.03)
        let deleteDot = SKAction.removeFromParent()
        let skiTrackSequence = SKAction.sequence([moveDot, deleteDot])
        skiTrack.run(skiTrackSequence)
        
   

    }
    
    func makeWall() {
        
        
        //This is used to count the score also, So it is important, But now the wall is a little different becasue, I am changin how the skier is on the map
        let wallSectionRight = SKSpriteNode(imageNamed: "greyDot")
        wallSectionRight.name = "WallSectionRight"
        wallSectionRight.setScale(0.6)
        wallSectionRight.position = CGPoint(x: self.size.width * (-0.2), y: self.size.height * 0.23)
        wallSectionRight.zPosition = 5
        wallSectionRight.physicsBody = SKPhysicsBody(circleOfRadius: max(120, 300))
        wallSectionRight.physicsBody?.affectedByGravity = false
        wallSectionRight.physicsBody!.categoryBitMask =  WallRight
        wallSectionRight.physicsBody!.collisionBitMask = 0
        wallSectionRight.physicsBody!.contactTestBitMask = Player
        self.addChild(wallSectionRight)

        let endPointRight = CGPoint(x: self.size.width * (-0.2), y: self.size.height * (-0.2))
        //rightWall
        let moveRightWall = SKAction.move(to: endPointRight, duration: 2)
        let deleteRightWall = SKAction.removeFromParent()
        let rightWallSequence = SKAction.sequence([moveRightWall, deleteRightWall])
        wallSectionRight.run(rightWallSequence)
        
        
//This is no longer needed because now I am using a different type of wall
        
        let wallSectionLeft = SKSpriteNode(imageNamed: "greyDot")
        wallSectionLeft.name = "WallSectionLeft"
        wallSectionLeft.setScale(0.6)
        wallSectionLeft.position = CGPoint(x: self.size.width * (1.2), y: self.size.height * 0.23)
        wallSectionLeft.zPosition = 5
        wallSectionLeft.physicsBody = SKPhysicsBody(circleOfRadius: max(120, 300))
        wallSectionLeft.physicsBody?.affectedByGravity = false
        wallSectionLeft.physicsBody!.categoryBitMask =  4
        wallSectionLeft.physicsBody!.collisionBitMask = 0
        wallSectionLeft.physicsBody!.contactTestBitMask = 1
        self.addChild(wallSectionLeft)
        
        let endPointLeft = CGPoint(x: self.size.width * (1.2), y: self.size.height * (-0.2))
        //LeftWall
        let moveLeftWall = SKAction.move(to: endPointLeft, duration: 2)
        let deleteLeftWall = SKAction.removeFromParent()
        let leftWallSequence = SKAction.sequence([moveLeftWall, deleteLeftWall])
        wallSectionLeft.run(leftWallSequence)
        
        
        
    }
    
    

    
    
    
    
    //function that defines the trees which are basically the enemy of the game
    func spawnTrees() {
        
        //the trees spawn randomly on the top of the screen and then move vertically downwards
        let n2 =  CGFloat((arc4random_uniform(10)))
        let r = CGFloat(n2 * 0.1)
        
        let startPoint2 = CGPoint(x: self.size.width * r, y: self.size.height * 1.2)
        
    
        let endPoint2 = CGPoint(x: self.size.width *  r, y: -self.size.height * 0.2)
        
        
       
        let tree = SKSpriteNode(imageNamed: "TreeDrawing")
        tree.name = "tree"
        tree.setScale(0.3)
        tree.position = startPoint2
        tree.zPosition = 5
        tree.physicsBody = SKPhysicsBody(circleOfRadius: max(40, 40))
        tree.physicsBody!.affectedByGravity = false
        tree.physicsBody!.categoryBitMask = Tree
        tree.physicsBody!.collisionBitMask = 0
        tree.physicsBody!.contactTestBitMask = Player
        self.addChild(tree)
        
        
   
        let moveTree = SKAction.move(to: endPoint2, duration: 5.3)
        let deleteTree = SKAction.removeFromParent()
        let treeSequence = SKAction.sequence([moveTree, deleteTree])
        tree.run(treeSequence)
        
        

        
        
        
    }
    
    
    
    
    
    //the "controller" of the game
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //the first tap changes the
        if currentGameState == gameState.preGame {
            startGame()
        }
        else if currentGameState == gameState.inGame {
      changeDirection()
        //boleans for which direction the player is going
        if check == false {
            direction = false

        }
        if check == true {
            direction = true

        }

        }

    }
    
    

}

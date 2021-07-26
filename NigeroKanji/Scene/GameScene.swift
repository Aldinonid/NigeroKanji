//
//  GameScene.swift
//  NigeroKanji
//
//  Created by Aldino Efendi on 2021/07/25.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    @objc var background:SKSpriteNode!
    var starfield:SKEmitterNode!
    var player:SKSpriteNode!
    let questionLabel = SKLabelNode(fontNamed: "theboldfont")
    let kanjiLebel1 = SKLabelNode(fontNamed: "theboldfont")
    let kanjiLebel2 = SKLabelNode(fontNamed: "theboldfont")
    let kanjiLebel3 = SKLabelNode(fontNamed: "theboldfont")
    let kanjiLebel4 = SKLabelNode(fontNamed: "theboldfont")
    let countDownLabel = SKLabelNode(fontNamed: "theboldfont")
    var levelTimerLabel = SKLabelNode(fontNamed: "theboldfont")
    

    var answer = answer1
    var question = question1
    var kanjiStage1 = [kanjiLevel1, kanjiLevel2!, kanjiLevel3!, kanjiLevel4!] as [Any]

    var levelNumber = 1
    var levelTimerValue: Int = 7 {
        didSet {
            levelTimerLabel.text = "Time left: \(levelTimerValue)"
        }
    }
    
    enum GameState{
        case preGame
        case inGame
        case afterGame
    }
    
//    var scoreLabel:SKLabelNode!
//    var score:Int = 0 {
//        didSet {
//            scoreLabel.text = "Score: \(score)"
//        }
//    }
    
    var gameTimer:Timer!
    
    var possibleAliens = ["alien", "alien2", "alien3"]
    
    var currentGameState = GameState.preGame
    
    let alienCategory:UInt32 = 0x1 << 1
    let photonTorpedoCategory:UInt32 = 0x1 << 0
    let gameArea: CGRect
    
    let motionManger = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height/maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        self.gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height)
        starfield.advanceSimulationTime(10)
        starfield.setScale(1.1)
        self.addChild(starfield)
        starfield.zPosition = 1
        
        
        runningBackground1()
        runningBackground2()
        timmer()
        
        // player
        player = SKSpriteNode(imageNamed: "shuttle")
        player.position = CGPoint(x: self.frame.size.width / 2, y: player.size.height / 2 + 150)
        player.setScale(5)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/4)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = photonTorpedoCategory
        player.physicsBody?.contactTestBitMask = alienCategory
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(player)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        levelTimerLabel.fontColor = SKColor.brown
        levelTimerLabel.fontSize = 100
        levelTimerLabel.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/1.08)
        addChild(levelTimerLabel)
        
        questionLabel.text = question
        questionLabel.numberOfLines = 3
        questionLabel.fontSize = 75
        questionLabel.horizontalAlignmentMode = .center
        questionLabel.fontColor = SKColor.brown
        questionLabel.preferredMaxLayoutWidth = self.frame.size.width/2
        questionLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        questionLabel.zPosition = 1
        self.addChild(questionLabel)
        

        kanjiLebel1.text = kanjiLevel1
        kanjiLebel1.fontSize = 175
        kanjiLebel1.fontColor = SKColor.brown
        kanjiLebel1.position = CGPoint(x: self.frame.size.width/3.75, y: self.frame.size.height/1.25)
        kanjiLebel1.zPosition = 1
        self.addChild(kanjiLebel1)
        
        kanjiLebel2.text = kanjiLevel2
        kanjiLebel2.fontSize = 175
        kanjiLebel2.fontColor = SKColor.brown
        kanjiLebel2.position = CGPoint(x: self.frame.size.width/2.375, y: self.frame.size.height/1.25)
        kanjiLebel2.zPosition = 1
        self.addChild(kanjiLebel2)
        
        kanjiLebel3.text = kanjiLevel3
        kanjiLebel3.fontSize = 175
        kanjiLebel3.fontColor = SKColor.brown
        kanjiLebel3.position = CGPoint(x: self.frame.size.width/1.75, y: self.frame.size.height/1.25)
        kanjiLebel3.zPosition = 1
        self.addChild(kanjiLebel3)
        
        kanjiLebel4.text = kanjiLevel4
        kanjiLebel4.fontSize = 175
        kanjiLebel4.fontColor = SKColor.brown
        kanjiLebel4.position = CGPoint(x: self.frame.size.width/1.375, y: self.frame.size.height/1.25)
        kanjiLebel4.zPosition = 1
        self.addChild(kanjiLebel4)
        
        
        
        spawnAlien()
        
        motionManger.accelerometerUpdateInterval = 0.2
        motionManger.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            }
        }
        
//        self.tapToStartLabel.text = "Tap To Begin"
//        self.tapToStartLabel.fontSize = 100
//        self.tapToStartLabel.fontColor = SKColor.white
//        self.tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
//        self.tapToStartLabel.zPosition = 1
//        self.tapToStartLabel.alpha = 0
//        self.addChild(self.tapToStartLabel)
//
//        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
//        self.tapToStartLabel.run(fadeInAction)
        
        startNewLevel()
        
    }
    
    func startGame(){
        
        self.currentGameState = GameState.inGame
        
//        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
//        let deleteAction = SKAction.removeFromParent()
//        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
//        self.tapToStartLabel.run(deleteSequence)
        
        let startLevelAction = SKAction.run(self.startNewLevel)
        let startGameSequence = SKAction.sequence([startLevelAction])
        self.run(startGameSequence)
    }
    
    @objc func runningBackground1() {
        background = SKSpriteNode(imageNamed: "MainGameScreen")
        background.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
//        starfield.advanceSimulationTime(10)
        background.setScale(1)
        let animationDuration:TimeInterval = 3.75
        background.zPosition = -1
        self.addChild(background)
        
        var actionBackground = [SKAction]()
        background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        actionBackground.append(SKAction.move(to: CGPoint(x: self.frame.size.width/2, y: -background.size.height), duration: animationDuration))
        background.run(SKAction.sequence(actionBackground))
        
//        background.run(SKAction.sequence(moveForever))
    }
    
    @objc func runningBackground2() {
        background = SKSpriteNode(imageNamed: "MainGameScreen")
        background.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
//        starfield.advanceSimulationTime(10)
        background.setScale(1)
        let animationDuration:TimeInterval = 2.5
        
        var actionBackground = [SKAction]()
        background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height+self.frame.size.height/2)
        actionBackground.append(SKAction.move(to: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), duration: animationDuration))
        background.run(SKAction.sequence(actionBackground))
        background.zPosition = -1
        self.addChild(background)
//        background.run(SKAction.sequence(moveForever))
    }
    
    @objc func timmer() {
        
        
        levelTimerLabel.text = "Time left: \(levelTimerValue)"
        let wait = SKAction.wait(forDuration: 1) //change countdown speed here
        let block = SKAction.run({
                [unowned self] in

                if self.levelTimerValue > 0{
                    self.levelTimerValue-=1
                }else{
//                    self.removeAction(forKey: "countdown")
                    var levelTimerValue: Int = 7 {
                        didSet {
                            levelTimerLabel.text = "Time left: \(levelTimerValue)"
                        }
                    }
                    timmer()
                }
            })
            let sequence = SKAction.sequence([wait,block])
        

        run(SKAction.repeatForever(sequence), withKey: "countdown")
//        levelTimerLabel.removeFromParent()
    }
//
    
    func spawnAlien() {
        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(2.5), target: self, selector: #selector(runningBackground1), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(2.5), target: self, selector: #selector(runningBackground2), userInfo: nil, repeats: true)
//        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(7), target: self, selector: #selector(timmer), userInfo: nil, repeats: true)
        
        if kanjiLebel1.text != answer {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAlien1), userInfo: nil, repeats: true)
        }
        if kanjiLebel2.text != answer {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAlien2), userInfo: nil, repeats: true)
        }
        if kanjiLebel3.text != answer {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAlien3), userInfo: nil, repeats: true)
        }
        if kanjiLebel4.text != answer{
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAlien4), userInfo: nil, repeats: true)
        }
    }
    
    func runGameOver(){
        
        self.currentGameState = GameState.afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet"){
            player, stop in
            
            player.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, stop in
            
            enemy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(self.changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    
    func changeScene(){

        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode

        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    
    //    lazy var randomQuestion:SKAction = {
    //
    //        for i in 0...1 {
    //            let texture = SKTexture(imageNamed: "human\(i + 1).png")
    //
    //            textures.append(texture)
    //        }
    //
    //        let action = SKAction.animate(with: textures, timePerFrame: 0.15, resize: true, restore: true)
    //
    //        return SKAction.repeatForever(action)
    //        }()
    
//    func loseLife(){
//
//        self.livesNumber -= 1
//        self.livesLabel.text = "Lives: \(self.livesNumber)"
//
//        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
//        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
//        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
//        self.livesLabel.run(scaleSequence)
//
//        if(self.livesNumber == 0){
//            self.runGameOver()
//        }
//
//    }
    
     
    
    
    @objc func addAlien1 () {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(5)
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: self.frame.size.width/3.75, y: self.frame.size.height + alien.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/3.75, y: -alien.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
        
    
    }
    
    @objc func addAlien2 () {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(5)
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: self.frame.size.width/2.375, y: self.frame.size.height + alien.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/2.375, y: -alien.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
        
    
    }
    
    @objc func addAlien3 () {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(5)
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: self.frame.size.width/1.75, y: self.frame.size.height + alien.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/1.75, y: -alien.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
        
    
    }
    
    @objc func addAlien4 () {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(5)
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: self.frame.size.width/1.375, y: self.frame.size.height + alien.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/1.375, y: -alien.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
        
    }
    
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        fireTorpedo()
//    }
    
    
//    func fireTorpedo() {
//        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
//
//        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
//        torpedoNode.position = player.position
//        torpedoNode.position.y += 5
//
//        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
//        torpedoNode.physicsBody?.isDynamic = true
//
//        torpedoNode.physicsBody?.categoryBitMask = photonTorpedoCategory
//        torpedoNode.physicsBody?.contactTestBitMask = alienCategory
//        torpedoNode.physicsBody?.collisionBitMask = 0
//        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
//
//        self.addChild(torpedoNode)
//
//        let animationDuration:TimeInterval = 0.3
//
//
//        var actionArray = [SKAction]()
//
//        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
//        actionArray.append(SKAction.removeFromParent())
//
//        torpedoNode.run(SKAction.sequence(actionArray))
//    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0 {
           torpedoDidCollideWithAlien(player: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
        }
        
        self.runGameOver()
        
    }
    
    
    func torpedoDidCollideWithAlien (player:SKSpriteNode, alienNode:SKSpriteNode) {
    
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        player.removeFromParent()
        alienNode.removeFromParent()
        
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
    }
    
    func startNewLevel(){
       
//       self.levelNumber += 1
//
//       if(self.action(forKey: "spawningEnemies") != nil){
//           self.removeAction(forKey: "spawningEnemies")
//       }
//
////       var levelDuration = TimeInterval()
//
//
//       switch levelNumber {
//       case 1:
//       case 2: var kanjiStage2 = [kanjiLevel1, kanjiLevel2!, kanjiLevel3!, kanjiLevel4!] as [Any]
//
//       default:
////           levelDuration = 0.5
//           print("cannot find level info")
//       }
//
//       let spawn = SKAction.run(self.spawnAlien)
////       let waitToSpawn = SKAction.wait(forDuration: 2)
//       let spawnSequence = SKAction.sequence([spawn])
//       let spawnForever = SKAction.repeatForever(spawnSequence)
//       self.run(spawnForever, withKey: "spawningEnemies")
   }
    
    override func didSimulatePhysics() {
        
        player.position.x += xAcceleration * 50
        
        if (self.player.position.x > (self.gameArea.maxX - self.player.size.width)){
            self.player.position.x = (self.gameArea.maxX - self.player.size.width)
        }

        if (self.player.position.x < (self.gameArea.minX + self.player.size.width)){
            self.player.position.x = (self.gameArea.minX + self.player.size.width)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

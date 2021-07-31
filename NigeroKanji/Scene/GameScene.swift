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
    var sakuraFalls:SKEmitterNode!
    var player:SKSpriteNode!
    let scoreLabel = SKLabelNode(fontNamed: "theboldfont.ttf")
    let livesLabel = SKLabelNode(fontNamed: "theboldfont.ttf")
    let questionLabel = SKLabelNode(fontNamed: "theboldfont.ttf")
    let kanjiLebel1 = SKLabelNode(fontNamed: "theboldfont.ttf")
    let kanjiLebel2 = SKLabelNode(fontNamed: "theboldfont.ttf")
    let kanjiLebel3 = SKLabelNode(fontNamed: "theboldfont.ttf")
    let kanjiLebel4 = SKLabelNode(fontNamed: "theboldfont.ttf")
    let countDownLabel = SKLabelNode(fontNamed: "theboldfont.ttf")
    var levelTimerLabel = SKLabelNode(fontNamed: "theboldfont.ttf")
    var answerLabel = SKLabelNode(fontNamed: "theboldfont.ttf")
    var model = Question()
//    var kanjiBallon1 = ""
//    var kanjiBallon2 = ""
//    var kanjiBallon3 = ""
//    var kanjiBallon4 = ""
//    var question = ""
    
//    var send = [kanjiBallon1, kanjiBallon2, kanjiBallon3, kanjiBallon4, question, answer]
    
    var livesNumber = 3
    var levelNumber = 1
    var levelTime = 7
    var levelTimerValue: Int = 7 {
        didSet {
            levelTimerLabel.text = "Time left: \(levelTimerValue)"
        }
    }
    
    var gameScore = 0
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    enum GameState{
        case preGame
        case inGame
        case afterGame
    }
    
    
    
    var gameTimer:Timer!
    
    var possibleAliens = "alien2"
    
    var currentGameState = GameState.preGame
    
    struct PhysicsCategories{
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1 //1
        static let Answer : UInt32 = 0b10 //2
        static let Alien: UInt32 = 0b100 //4
    }
    
    let alienCategory:UInt32 = 0x1 << 1
    let answerCategory:UInt32 = 0x1 << 1
    let playerCategory:UInt32 = 0x1 << 1
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
        
        sakuraFalls = SKEmitterNode(fileNamed: "Starfield")
        sakuraFalls.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height)
        sakuraFalls.advanceSimulationTime(10)
        sakuraFalls.setScale(1.1)
        self.addChild(sakuraFalls)
        sakuraFalls.zPosition = 1
        
        runningBackground1()
        runningBackground2()
        
        model.showKanji()
        let kanjiBallon1 = model.screenKanji1.karakter
        let kanjiBallon2 = model.screenKanji2.karakter
        let kanjiBallon3 = model.screenKanji3.karakter
        let kanjiBallon4 = model.screenKanji4.karakter
        let question = model.kanjiArti
        let answer = model.kanjiKarakter
        
        if kanjiBallon1 != answer {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAlien1), userInfo: nil, repeats: false)
        }else {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAnswer1), userInfo: nil, repeats: false)
        }
        if kanjiBallon2 != answer{
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAlien2), userInfo: nil, repeats: false)
        }else {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAnswer2), userInfo: nil, repeats: false)
        }
        if kanjiBallon3 != answer {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAlien3), userInfo: nil, repeats: false)
        }else {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAnswer3), userInfo: nil, repeats: false)
        }
        if kanjiBallon4 != answer {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAlien4), userInfo: nil, repeats: false)
        }else {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAnswer4), userInfo: nil, repeats: false)
        }
        
        self.questionLabel.text = "coba tebak kanji mana yang artinya \"\(question)\""
        questionLabel.numberOfLines = 3
        questionLabel.fontSize = 75
        questionLabel.horizontalAlignmentMode = .center
        questionLabel.fontColor = SKColor.brown
        questionLabel.preferredMaxLayoutWidth = self.frame.size.width/2
        questionLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        questionLabel.zPosition = 1
        self.addChild(questionLabel)
        
        answerLabel.text = answer
        answerLabel.fontSize = 100
        answerLabel.fontColor = SKColor.brown
        answerLabel.preferredMaxLayoutWidth = self.frame.size.width/2
        answerLabel.position = CGPoint(x: self.size.width/2, y: (self.size.height/2) - 300)
        answerLabel.zPosition = 1
        self.addChild(answerLabel)
        
        kanjiLebel1.text = kanjiBallon1
        kanjiLebel1.fontSize = 175
        kanjiLebel1.fontColor = SKColor.brown
        kanjiLebel1.position = CGPoint(x: self.frame.size.width/3.75, y: self.frame.size.height/1.25)
        kanjiLebel1.zPosition = 1
        self.addChild(kanjiLebel1)
        
        kanjiLebel2.text = kanjiBallon2
        kanjiLebel2.fontSize = 175
        kanjiLebel2.fontColor = SKColor.brown
        kanjiLebel2.position = CGPoint(x: self.frame.size.width/2.375, y: self.frame.size.height/1.25)
        kanjiLebel2.zPosition = 1
        self.addChild(kanjiLebel2)
        
        kanjiLebel3.text = kanjiBallon3
        kanjiLebel3.fontSize = 175
        kanjiLebel3.fontColor = SKColor.brown
        kanjiLebel3.position = CGPoint(x: self.frame.size.width/1.75, y: self.frame.size.height/1.25)
        kanjiLebel3.zPosition = 1
        self.addChild(kanjiLebel3)
        
        
        kanjiLebel4.text = kanjiBallon4
        kanjiLebel4.fontSize = 175
        kanjiLebel4.fontColor = SKColor.brown
        kanjiLebel4.position = CGPoint(x: self.frame.size.width/1.375, y: self.frame.size.height/1.25)
        kanjiLebel4.zPosition = 1
        self.addChild(kanjiLebel4)
        
        // player
        player = SKSpriteNode(imageNamed: "ninc2")
        player.position = CGPoint(x: self.frame.size.width / 2, y: player.size.height / 2 + 150)
        player.setScale(1)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/4)
        player.physicsBody?.isDynamic = true
//        player.physicsBody?.categoryBitMask = playerCategory
//        player.physicsBody?.contactTestBitMask = alienCategory & answerCategory
//        player.physicsBody?.collisionBitMask = 0
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Alien | PhysicsCategories.Answer
        player.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(player)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        self.scoreLabel.text = "Score: 0"
        self.scoreLabel.fontSize = 70
        self.scoreLabel.fontColor = SKColor.brown
        self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.scoreLabel.position = CGPoint(x: self.frame.size.width/7.8, y: self.frame.size.height/1.08)
        self.scoreLabel.zPosition = 100
        self.addChild(self.scoreLabel)
        
        self.livesLabel.text = "Lives: 3"
        self.livesLabel.fontSize = 70
        self.livesLabel.fontColor = SKColor.brown
        self.livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        self.livesLabel.position = CGPoint(x: self.frame.size.width/1.130, y: self.frame.size.height/1.08)
        self.livesLabel.zPosition = 100
        self.addChild(self.livesLabel)
        
        // Timer
        levelTimerLabel.fontColor = SKColor.brown
        levelTimerLabel.fontSize = 100
        levelTimerLabel.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/1.08)
        addChild(levelTimerLabel)
        
        
        playerMove()
        spawn()
        timmer()
//        kanjiLabel()
        
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
        
//        startNewLevel()
        
    }
    
    @objc func showKanji() {
//        model.showKanji()
//        let kanjiBallon1 = model.screenKanji1.karakter
//        let kanjiBallon2 = model.screenKanji2.karakter
//        let kanjiBallon3 = model.screenKanji3.karakter
//        let kanjiBallon4 = model.screenKanji4.karakter
//        let question = model.kanjiArti
//        let answer = model.kanjiKarakter
//
//        scoreLabel.text = "Score: \(gameScore)"
//        self.kanjiLebel1.text = kanjiBallon1
//        self.kanjiLebel2.text = kanjiBallon2
//        self.kanjiLebel3.text = kanjiBallon3
//        self.kanjiLebel4.text = kanjiBallon4
//        self.questionLabel.text = "coba tebak kanji mana yang artinya : \"\(question)\""
//        self.answerLabel.text = answer
        
    }
    
    @objc func kanjiLabel(){
//        let block = SKAction.run({ [self] in
//            model.showKanji()
//            let kanjiBallon1 = model.screenKanji1.karakter
//            let kanjiBallon2 = model.screenKanji2.karakter
//            let kanjiBallon3 = model.screenKanji3.karakter
//            let kanjiBallon4 = model.screenKanji4.karakter
//            let question = model.kanjiArti
//            let answer = model.kanjiKarakter
//
//
//            })
//
//        let wait = SKAction.wait(forDuration: 2)
//        let sequence = SKAction.sequence([wait, block])
//
//        run(SKAction.repeatForever(sequence))
        
        model.showKanji()
        let kanjiBallon1 = model.screenKanji1.karakter
        let kanjiBallon2 = model.screenKanji2.karakter
        let kanjiBallon3 = model.screenKanji3.karakter
        let kanjiBallon4 = model.screenKanji4.karakter
        let question = model.kanjiArti
        let answer = model.kanjiKarakter
        
        scoreLabel.text = "Score: \(gameScore)"
        self.kanjiLebel1.text = kanjiBallon1
        self.kanjiLebel2.text = kanjiBallon2
        self.kanjiLebel3.text = kanjiBallon3
        self.kanjiLebel4.text = kanjiBallon4
        self.questionLabel.text = "coba tebak kanji mana yang artinya \"\(question)\""
        self.answerLabel.text = answer
        
        

//        if kanjiBallon1 != answer {
//            addAlien1()
//            kanjiLebel1.fontColor = SKColor.brown
//        }else {
////            addAnswer()
//            kanjiLebel1.fontColor = SKColor.red
//        }
//
//        if kanjiBallon2 != answer {
//            addAlien2()
//            kanjiLebel2.fontColor = SKColor.brown
//        }else {
////            addAnswer()
//            kanjiLebel2.fontColor = SKColor.red
//        }
//
//        if kanjiBallon3 != answer {
//            addAlien3()
//            kanjiLebel3.fontColor = SKColor.brown
//        }else {
////            addAnswer()
//            kanjiLebel3.fontColor = SKColor.red
//        }
//
//        if kanjiBallon4 != answer {
//            addAlien4()
//            kanjiLebel4.fontColor = SKColor.brown
//        }else {
////            addAnswer()
//            kanjiLebel4.fontColor = SKColor.red
//        }
        print(kanjiBallon1, kanjiBallon2, kanjiBallon3, kanjiBallon4, question, answer)
       
        
        if kanjiBallon1 != answer {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAlien1), userInfo: nil, repeats: false)
        }else {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAnswer1), userInfo: nil, repeats: false)
        }
        if kanjiBallon2 != answer{
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAlien2), userInfo: nil, repeats: false)
        }else {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAnswer2), userInfo: nil, repeats: false)
        }
        if kanjiBallon3 != answer {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAlien3), userInfo: nil, repeats: false)
        }else {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAnswer3), userInfo: nil, repeats: false)
        }
        if kanjiBallon4 != answer {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAlien4), userInfo: nil, repeats: false)
        }else {
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(addAnswer4), userInfo: nil, repeats: false)
        }
    }
    
    @objc func playerMove() {
        let textureAtlas = SKTextureAtlas(named: "Player")
        let frame0 = textureAtlas.textureNamed("ninc1")
        let frame1 = textureAtlas.textureNamed("ninc2")
        let frame2 = textureAtlas.textureNamed("ninc3")
        let frame3 = textureAtlas.textureNamed("ninc4")
        let player1texture = [frame0,frame1,frame2,frame3]
        
        let animateAction = SKAction.animate(with: player1texture, timePerFrame: 0.15)
        player.run(animateAction)
    }
    
    
//    func startGame(){
//
//        self.currentGameState = GameState.inGame
//
////        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
////        let deleteAction = SKAction.removeFromParent()
////        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
////        self.tapToStartLabel.run(deleteSequence)
//
//        let startLevelAction = SKAction.run(self.startNewLevel)
//        let startGameSequence = SKAction.sequence([startLevelAction])
//        self.run(startGameSequence)
//    }
    
    @objc func runningBackground1() {
        background = SKSpriteNode(imageNamed: "MainGameScreen")
        background.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        background.setScale(1)
        background.zPosition = -1
        self.addChild(background)
        let animationDuration:TimeInterval = 3.75
        var actionBackground = [SKAction]()
        background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        actionBackground.append(SKAction.move(to: CGPoint(x: self.frame.size.width/2, y: -background.size.height), duration: animationDuration))
        background.run(SKAction.sequence(actionBackground))
        
    }
    
    @objc func runningBackground2() {
        background = SKSpriteNode(imageNamed: "MainGameScreen")
        background.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        background.setScale(1)
        let animationDuration:TimeInterval = 2.5
        self.addChild(background)
        var actionBackground = [SKAction]()
        background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height+self.frame.size.height/2)
        actionBackground.append(SKAction.move(to: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), duration: animationDuration))
        background.run(SKAction.sequence(actionBackground))
        background.zPosition = -1

    }
    
    @objc func timmer() {
        
        levelTimerLabel.text = "Time left: \(levelTimerValue)"
        let wait = SKAction.wait(forDuration: 1) //change countdown speed here
        let block = SKAction.run({
                [unowned self] in

                if levelTimerValue > 0{
                   levelTimerValue -= 1
                }else{
                   levelTimerValue = levelTime
                    kanjiLabel()
                }
            })
            let sequence = SKAction.sequence([block, wait])
    
        run(SKAction.repeatForever(sequence))
    }
    
    
    func spawn() {
        
        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.6), target: self, selector: #selector(playerMove), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(2.5), target: self, selector: #selector(runningBackground1), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(2.5), target: self, selector: #selector(runningBackground2), userInfo: nil, repeats: true)
//        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue), target: self, selector: #selector(kanjiLabel), userInfo: nil, repeats: true)
//        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelTimerValue+2), target: self, selector: #selector(showKanji), userInfo: nil, repeats: true)
    }
    
    
    
    func runGameOver(){
        
        self.currentGameState = GameState.afterGame
        
        self.removeAllActions()
        
//        self.enumerateChildNodes(withName: "Bullet"){
//            player, stop in
//
//            player.removeAllActions()
//        }
//
//        self.enumerateChildNodes(withName: "Enemy"){
//            enemy, stop in
//
//            enemy.removeAllActions()
//        }
        
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
    
    func addScore(){
        
        gameScore += 1
        self.scoreLabel.text = "Score: \(gameScore)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        self.scoreLabel.run(scaleSequence)
        
//        if(gameScore == 10 || gameScore == 25 || gameScore == 50){
//            self.startNewLevel()
//        }
        
    }
    
    func loseLife(){

        self.livesNumber -= 1
        self.livesLabel.text = "Lives: \(self.livesNumber)"

        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        self.livesLabel.run(scaleSequence)

        if(self.livesNumber == 0){
            player.removeFromParent()
            self.runGameOver()
        }

    }
    
    @objc func addAnswer1 () {
//        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let spawnAnswer = SKSpriteNode(imageNamed: "alien")
        
        spawnAnswer.physicsBody = SKPhysicsBody(rectangleOf: spawnAnswer.size)
        spawnAnswer.physicsBody?.isDynamic = true
        spawnAnswer.setScale(5)
        
//        spawnAnswer.physicsBody?.categoryBitMask = answerCategory
//        spawnAnswer.physicsBody?.contactTestBitMask = playerCategory
//        spawnAnswer.physicsBody?.collisionBitMask = 0
        spawnAnswer.physicsBody!.categoryBitMask = PhysicsCategories.Answer
        spawnAnswer.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnAnswer.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(spawnAnswer)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        spawnAnswer.position = CGPoint(x: self.frame.size.width/3.75, y: self.frame.size.height + spawnAnswer.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/3.75, y: -spawnAnswer.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        spawnAnswer.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAnswer2 () {
//        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let spawnAnswer = SKSpriteNode(imageNamed: "alien")
        
        spawnAnswer.physicsBody = SKPhysicsBody(rectangleOf: spawnAnswer.size)
        spawnAnswer.physicsBody?.isDynamic = true
        spawnAnswer.setScale(5)
        
//        spawnAnswer.physicsBody?.categoryBitMask = answerCategory
//        spawnAnswer.physicsBody?.contactTestBitMask = playerCategory
//        spawnAnswer.physicsBody?.collisionBitMask = 0
        spawnAnswer.physicsBody!.categoryBitMask = PhysicsCategories.Answer
        spawnAnswer.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnAnswer.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(spawnAnswer)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        spawnAnswer.position = CGPoint(x: self.frame.size.width/2.375, y: self.frame.size.height + spawnAnswer.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/2.375, y: -spawnAnswer.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        spawnAnswer.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAnswer3 () {
//        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let spawnAnswer = SKSpriteNode(imageNamed: "alien")
        
        spawnAnswer.physicsBody = SKPhysicsBody(rectangleOf: spawnAnswer.size)
        spawnAnswer.physicsBody?.isDynamic = true
        spawnAnswer.setScale(5)
        
//        spawnAnswer.physicsBody?.categoryBitMask = answerCategory
//        spawnAnswer.physicsBody?.contactTestBitMask = playerCategory
//        spawnAnswer.physicsBody?.collisionBitMask = 0
        spawnAnswer.physicsBody!.categoryBitMask = PhysicsCategories.Answer
        spawnAnswer.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnAnswer.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(spawnAnswer)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        spawnAnswer.position = CGPoint(x: self.frame.size.width/1.75, y: self.frame.size.height + spawnAnswer.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/1.75, y: -spawnAnswer.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        spawnAnswer.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAnswer4 () {
//        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let spawnAnswer = SKSpriteNode(imageNamed: "alien")
        
        spawnAnswer.physicsBody = SKPhysicsBody(rectangleOf: spawnAnswer.size)
        spawnAnswer.physicsBody?.isDynamic = true
        spawnAnswer.setScale(5)
        
//        spawnAnswer.physicsBody?.categoryBitMask = answerCategory
//        spawnAnswer.physicsBody?.contactTestBitMask = playerCategory
//        spawnAnswer.physicsBody?.collisionBitMask = 0
        spawnAnswer.physicsBody!.categoryBitMask = PhysicsCategories.Answer
        spawnAnswer.physicsBody!.collisionBitMask = PhysicsCategories.None
        spawnAnswer.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(spawnAnswer)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        spawnAnswer.position = CGPoint(x: self.frame.size.width/1.375, y: self.frame.size.height + spawnAnswer.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/1.375, y: -spawnAnswer.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        spawnAnswer.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAlien1 () {
//        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(5)
        
//        alien.physicsBody?.categoryBitMask = alienCategory
//        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
//        alien.physicsBody?.collisionBitMask = 0
        alien.physicsBody!.categoryBitMask = PhysicsCategories.Alien
        alien.physicsBody!.collisionBitMask = PhysicsCategories.None
        alien.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: self.frame.size.width/3.75, y: self.frame.size.height + alien.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/3.75, y: -alien.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addAlien2 () {
//        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(5)
        
//        alien.physicsBody?.categoryBitMask = alienCategory
//        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
//        alien.physicsBody?.collisionBitMask = 0
        alien.physicsBody!.categoryBitMask = PhysicsCategories.Alien
        alien.physicsBody!.collisionBitMask = PhysicsCategories.None
        alien.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: self.frame.size.width/2.375, y: self.frame.size.height + alien.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/2.375, y: -alien.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
        
    }
    
    @objc func addAlien3 () {
//        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(5)
        
//        alien.physicsBody?.categoryBitMask = alienCategory
//        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
//        alien.physicsBody?.collisionBitMask = 0
        alien.physicsBody!.categoryBitMask = PhysicsCategories.Alien
        alien.physicsBody!.collisionBitMask = PhysicsCategories.None
        alien.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        alien.position = CGPoint(x: self.frame.size.width/1.75, y: self.frame.size.height + alien.size.height) // start poin
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width/1.75, y: -alien.size.height), duration: animationDuration)) // end poin
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
        
    }
    
    @objc func addAlien4 () {
//        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.setScale(5)
        
//        alien.physicsBody?.categoryBitMask = alienCategory
//        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
//        alien.physicsBody?.collisionBitMask = 0
        alien.physicsBody!.categoryBitMask = PhysicsCategories.Alien
        alien.physicsBody!.collisionBitMask = PhysicsCategories.None
        alien.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
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
//        var firstBody:SKPhysicsBody
//        var secondBody:SKPhysicsBody
//
//        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
//            firstBody = contact.bodyA
//            secondBody = contact.bodyB
////            let loseALife = SKAction.run(self.loseLife)
////            let enemySequence = SKAction.sequence([loseALife])
////                run(enemySequence)
//        }else{
//            firstBody = contact.bodyB
//            secondBody = contact.bodyA
////            let loseALife = SKAction.run(self.loseLife)
////            let enemySequence = SKAction.sequence([loseALife])
////                run(enemySequence)
//
//        }
////        addScore()
//        if (firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0 {
//           torpedoDidCollideWithAlien(player: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
//            let loseALife = SKAction.run(self.loseLife)
//            let enemySequence = SKAction.sequence([loseALife])
//                run(enemySequence)
//        }
//
//        if (firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & answerCategory) != 0 {
//            torpedoDidCollideWithAlien(player: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
//            addScore()
//        }
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()

        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if(body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Alien){
            
            //if player hits enemy
            if(body1.node != nil){
//                self.spawnExplosion(spawnPosition: body1.node!.position)
                body2.node?.removeFromParent()
                let loseALife = SKAction.run(self.loseLife)
                let enemySequence = SKAction.sequence([loseALife])
                    run(enemySequence)
            }
            
//            if(body2.node != nil){
//                self.spawnExplosion(spawnPosition: body2.node!.position)
//            }
//
//
//            body1.node?.removeFromParent()
//            body2.node?.removeFromParent()
//            self.runGameOver()
        }
        
        if(body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Answer){
            
            //if bullet hits enemy
            if(body1.node != nil){
                addScore()
                body2.node?.removeFromParent()
//                if(body2.node!.position.y > self.size.height){
//                    return
//                } else {
                    
                    //spawnExplosion
//                    self.spawnExplosion(spawnPosition: body2.node!.position)
//                    self.addScore()
//                    body1.node?.removeFromParent()
//                    body2.node?.removeFromParent()
//                }
            }
            
        }
        
    }
    
    
    func torpedoDidCollideWithAlien (player:SKSpriteNode, alienNode:SKSpriteNode) {
    
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
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

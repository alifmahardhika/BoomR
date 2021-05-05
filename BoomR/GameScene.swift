//
//  GameScene.swift
//  BoomR
//
//  Created by Alif Mahardhika on 30/04/21.
//

import SpriteKit
import GameplayKit
import CoreMotion


protocol TransitionDelegate: SKSceneDelegate {
    func returnToMainMenu()
    func retry()
}


class GameScene: SKScene, SKPhysicsContactDelegate {
//    var gameSceneDelegate
    
    var manager = CMMotionManager()
    var player = SKSpriteNode()
    var monster = SKSpriteNode()
    var wall = SKSpriteNode()
    var levelDetail = Level(life: 3, monsterCount: 2)
    var lifeArr : [SKSpriteNode] = []
    var monsterArr : [SKSpriteNode] = []
//    var pauseBlock = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
//        life indicator
        _ = 0
        var positionAdd:CGFloat = 10.0

        for _ in 0..<levelDetail.life {

            let lifeIndex = SKSpriteNode(imageNamed: "ball")
            lifeIndex.size = CGSize(width: 20, height: 20)

            lifeIndex.position = CGPoint(x: self.frame.size.width * -5.5, y: 735)

            let lifeIndexMove = SKAction.move(to: CGPoint(x: (size.width * 0.05) + positionAdd, y: 735), duration: TimeInterval(0.7))

            let lifeIndexRotation = SKAction.rotate(byAngle: CGFloat(-2 * Double.pi), duration: 0.3)

            lifeIndex.run(SKAction.sequence([lifeIndexMove, lifeIndexRotation]))

            addChild(lifeIndex)
            lifeArr.append(lifeIndex)

            positionAdd = positionAdd + 30.0

        }
        
//        monster indicator
        _ = 0
        var _:CGFloat = 0

        for _ in 0..<levelDetail.monsterCount {

            let monIndex = SKSpriteNode(imageNamed: "alien")
            monIndex.size = CGSize(width: 25, height: 25)

            monIndex.position = CGPoint(x: self.frame.size.width * 5.5, y: 735)
            
            let monsterIndex = SKAction.move(to: CGPoint(x: 460 - positionAdd, y: 735), duration: TimeInterval(0.7))

            let monIndexRot = SKAction.rotate(byAngle: CGFloat(-2 * Double.pi), duration: 0.3)

            monIndex.run(SKAction.sequence([monsterIndex, monIndexRot]))

            addChild(monIndex)
            monsterArr.append(monIndex)
            positionAdd = positionAdd + 30.0

        }
        
        
        
        player = self.childNode(withName: "player") as! SKSpriteNode
        monster = self.childNode(withName: "monster") as! SKSpriteNode
        wall = self.childNode(withName: "wall") as! SKSpriteNode
        
        
        player.position = CGPoint(x: frame.midX, y: frame.midY)
        self.centerPlayer()
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.height / 2.0)
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        manager.startAccelerometerUpdates(to: OperationQueue.main){
            (data, error) in
            
            self.physicsWorld.gravity = CGVector(dx: CGFloat((data?.acceleration.x)!) * 20, dy: CGFloat((data?.acceleration.y)!) * 20)
            
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("came here")
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        print(bodyA.categoryBitMask)
        print(bodyB.categoryBitMask)

//        1 = wall
//        2 = monster
//        42949.. = player
        if bodyA.categoryBitMask == 4294967295 && bodyB.categoryBitMask == 2 || bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 4294967295 {
            print("HIT MONSTER")
            explode(player: player, crashed: bodyA.node!)
            print("called explode")
        }
        else if bodyA.categoryBitMask == 4294967295 && bodyB.categoryBitMask == 1 || bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 4294967295 {
            print("HIT WALL")
            explode(player: player, crashed: bodyA.node!)
            print("called explode")
        }

    }
//    
    deinit {
        print("DEINITED")
    }
    
    
//    pause on touch
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
       
        next?.touchesBegan(touches, with: event)
        
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)

        if let name = touchedNode.name
        {
            if name == "tryAgain" || name == "innerMenu" || name == "backToMenu"
            {
                print("Touched")
                if name == "backToMenu" {
                    self.run(SKAction.wait(forDuration: 0),completion:{[unowned self] in
                        guard let delegate = self.delegate else { return }
                        self.view?.presentScene(nil)
                        (delegate as! TransitionDelegate).returnToMainMenu()
                    })
                }
                else if name == "tryAgain"{
                    print("retry")
                    print(self.name)
                    self.removeAllChildren()
                    self.removeAllActions()
                    self.run(SKAction.wait(forDuration: 0),completion:{[unowned self] in
                        guard let delegate = self.delegate else { return }
                        self.view?.presentScene(nil)
                        (delegate as! TransitionDelegate).retry()
                    })

                }
                return
            }
        }

//
        if let pauseBlock = childNode(withName: "//pauseBlock") as! SKSpriteNode?{
            if let inner = childNode(withName: "//innerMenu") as! SKShapeNode?{
                inner.removeFromParent()
            }
//            pause to play
            pauseBlock.removeFromParent()
            self.physicsWorld.speed = 1
            return
        }
//            play to pause
        
        let pauseBlock = createPauseBlock()
        pauseBlock.position = CGPoint(x: frame.midX, y: frame.midY)
        pauseBlock.name = "pauseBlock"
        self.addChild(pauseBlock)
//            scene?.view?.isPaused = true
        self.physicsWorld.speed = 0
    
    }
    
    func createPauseBlock() -> SKSpriteNode{
        let pauseBlock = SKSpriteNode(color: UIColor .gray, size: CGSize(width: 400, height:850))
        pauseBlock.alpha = 0.5
        pauseBlock.position = CGPoint(x: frame.midX, y: frame.midY)
        
        self.addChild(createMenuBlock())
//        createMenuBlock()
        return pauseBlock
    }
    
    func createInnerMenuDisplay(inner: SKShapeNode){
        var header: SKLabelNode!
        header = SKLabelNode(fontNamed: "Arial-BoldMT")
        header.text = "TIMEOUT!"
        header.name = "innerMenu"
        header.fontSize = 26
        header.fontColor = UIColor .black
        header.horizontalAlignmentMode = .right
        header.position = CGPoint(x: inner.frame.midX+60, y: inner.frame.midY+80)
        
        
        var midEmoji: SKLabelNode!
        midEmoji = SKLabelNode(fontNamed: "Arial-BoldMT")
        midEmoji.text = "⏳⏳⏳"
        midEmoji.name = "innerMenu"
        midEmoji.fontSize = 26
        midEmoji.fontColor = UIColor .black
        midEmoji.horizontalAlignmentMode = .right
        midEmoji.position = CGPoint(x: inner.frame.midX+40, y: inner.frame.midY-10)
        
        var menuMessage: SKLabelNode!
        menuMessage = SKLabelNode(fontNamed: "Arial-MT")
        menuMessage.text = "The game is paused"
        menuMessage.name = "innerMenu"
        menuMessage.fontSize = 20
        menuMessage.fontColor = UIColor .black
        menuMessage.horizontalAlignmentMode = .right
        menuMessage.position = CGPoint(x: inner.frame.midX+90, y: inner.frame.midY-100)
        
        inner.addChild(header)
        inner.addChild(midEmoji)
        inner.addChild(menuMessage)

    }
    
    func createMenuBlock() -> SKShapeNode {
        let inner = SKShapeNode(rect: CGRect(x: frame.midX - 130, y: frame.midY - 80, width: 260, height: 300), cornerRadius: 10)
        inner.fillColor = hexStringToUIColor(hex:"#FFDC00")
        inner.strokeColor = UIColor .black
        inner.zPosition = 1
//        inner.position = CGPoint(self.size.width * 0.5, self.size.height * 0.5)
//        inner.position = CGPoint(x: frame.midX - 130, y: frame.midY - 80)
        inner.name = "innerMenu"
        createInnerMenuDisplay(inner: inner)
//        button
        let tryAgain = SKShapeNode(rect: CGRect(x: frame.midX - 130 , y: frame.midY - 140, width: 260, height: 50), cornerRadius: 10)
        tryAgain.fillColor = hexStringToUIColor(hex:"#F42C48")
        tryAgain.strokeColor = UIColor .black
        tryAgain.zPosition = 1
        tryAgain.name = "tryAgain"
        
        var tryLabel: SKLabelNode!
        tryLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        tryLabel.text = "TRY AGAIN"
        tryLabel.name = "tryAgain"
        
        tryLabel.fontSize = 17
        tryLabel.horizontalAlignmentMode = .right
        tryLabel.position = CGPoint(x: tryAgain.frame.midX+47, y: tryAgain.frame.midY-8)
        tryAgain.addChild(tryLabel)
        inner.addChild(tryAgain)
        
        
//        button menu
        let backToMenu = SKShapeNode(rect: CGRect(x: frame.midX - 130 , y: frame.midY - 200, width: 260, height: 50), cornerRadius: 10)
        backToMenu.fillColor = hexStringToUIColor(hex:"#FFDC00")
        backToMenu.strokeColor = UIColor .black
        backToMenu.zPosition = 1
//        inner.position = CGPoint(self.size.width * 0.5, self.size.height * 0.5)
//        tryAgain.position = CGPoint(x: frame.midX, y: frame.midY)
        backToMenu.name = "backToMenu"
        
        var menuLabel: SKLabelNode!
        menuLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        menuLabel.fontColor = UIColor .black
        menuLabel.text = "Back to menu"
        menuLabel.name = "backToMenu"
        
        menuLabel.fontSize = 17
        menuLabel.horizontalAlignmentMode = .right
        menuLabel.position = CGPoint(x: backToMenu.frame.midX+53, y: backToMenu.frame.midY-8)
        backToMenu.addChild(menuLabel)
        inner.addChild(backToMenu)
        
        
//        self.addChild(inner)
        return inner
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func explode(player: SKNode, crashed: SKNode) {
        if let sparkEmitter = SKEmitterNode(fileNamed: "Spark") {
            sparkEmitter.position = crashed.position
            addChild(sparkEmitter)
        }
        
        if let smokeEmitter = SKEmitterNode(fileNamed: "Smoke") {
            smokeEmitter.position = crashed.position
            addChild(smokeEmitter)
        }
        if let fireEmitter = SKEmitterNode(fileNamed: "Fire") {
            fireEmitter.position = crashed.position
            addChild(fireEmitter)
        }
        

        player.removeFromParent()
        crashed.removeFromParent()
        
        self.updateAfterHit(crashed: crashed)
        
        self.run(SKAction.wait(forDuration: 2)) {
            self.addChild(player)
            self.centerPlayer()
        }
//        addChild(player)
    }
    
    func centerPlayer() {
        player.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        let moveAction = SKAction.move(to: CGPoint(x: 194.022, y: 198.448), duration: 0.0)
        player.run(moveAction)
    }
    
    func updateAfterHit(crashed: SKNode){
        if (crashed.name == "monster"){
            print("getin")
            levelDetail.monsterCount -= 1
            let monNode = self.monsterArr.popLast()
            monNode!.removeFromParent()
            if levelDetail.monsterCount == 0 {
                print("menank")
//                todo win seq
            }
        }
        levelDetail.life -= 1
        let lifeNode = self.lifeArr.popLast()
        lifeNode!.removeFromParent()
        if (levelDetail.life == 0){
            print("KALAH")
//            todo failed seq
        }
        print(levelDetail)
    }
}

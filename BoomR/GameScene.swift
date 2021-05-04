//
//  GameScene.swift
//  BoomR
//
//  Created by Alif Mahardhika on 30/04/21.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    var manager = CMMotionManager()
    var player = SKSpriteNode()
    var monster = SKSpriteNode()
    var wall = SKSpriteNode()
    var levelDetail = Level(life: 3, monsterCount: 2)
    var lifeArr : [SKSpriteNode] = []
    var monsterArr : [SKSpriteNode] = []
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
//        life indicator
        var lifeIndexCount = 0
        var positionAdd:CGFloat = 10.0

        for lifeIndexCount in 0..<levelDetail.life {

            let lifeIndex = SKSpriteNode(imageNamed: "ball")
            lifeIndex.size = CGSize(width: 20, height: 20)

            lifeIndex.position = CGPoint(x: self.frame.size.width * -5.5, y: 735)

            let lifeIndexMove = SKAction.move(to: CGPoint(x: (size.width * 0.05) + positionAdd, y: 735), duration: TimeInterval(0.7))

            let lifeIndexRotation = SKAction.rotate(byAngle: CGFloat(-2 * M_PI), duration: 0.3)

            lifeIndex.run(SKAction.sequence([lifeIndexMove, lifeIndexRotation]))

            addChild(lifeIndex)
            lifeArr.append(lifeIndex)

            positionAdd = positionAdd + 30.0

        }
        
//        monster indicator
        var monsterIndexCount = 0
        var monPositionAdd:CGFloat = 0

        for monsterIndexCount in 0..<levelDetail.monsterCount {

            let monIndex = SKSpriteNode(imageNamed: "alien")
            monIndex.size = CGSize(width: 25, height: 25)

            monIndex.position = CGPoint(x: self.frame.size.width * 5.5, y: 735)
            
            let monsterIndex = SKAction.move(to: CGPoint(x: 460 - positionAdd, y: 735), duration: TimeInterval(0.7))

            let monIndexRot = SKAction.rotate(byAngle: CGFloat(-2 * M_PI), duration: 0.3)

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
    
//    pause on touch
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
       
        next?.touchesBegan(touches, with: event)
       
        scene?.view?.isPaused = !(scene?.view!.isPaused)!
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if scene?.view?.isPaused == true {
            print("PAUSED")
        }
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

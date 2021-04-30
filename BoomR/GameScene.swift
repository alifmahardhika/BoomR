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
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        player = self.childNode(withName: "player") as! SKSpriteNode
        monster = self.childNode(withName: "monster") as! SKSpriteNode
        wall = self.childNode(withName: "wall") as! SKSpriteNode
        
        
        player.position = CGPoint(x: frame.midX, y: frame.midY)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.height / 2.0)
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        manager.startAccelerometerUpdates(to: OperationQueue.main){
            (data, error) in
            
            self.physicsWorld.gravity = CGVector(dx: CGFloat((data?.acceleration.x)!) * 10, dy: CGFloat((data?.acceleration.y)!) * 10)
            
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("came here")
        var bodyA = contact.bodyA
        var bodyB = contact.bodyB
        
        print(bodyA.categoryBitMask)
        print(bodyB.categoryBitMask)

//        1 = wall
//        2 = monster
//        42949.. = player
        if bodyA.categoryBitMask == 4294967295 && bodyB.categoryBitMask == 2 || bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 4294967295 {
            print("HIT MONSTER")
        }
        else if bodyA.categoryBitMask == 4294967295 && bodyB.categoryBitMask == 1 || bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 4294967295 {
            print("HIT WALL")
        }

    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

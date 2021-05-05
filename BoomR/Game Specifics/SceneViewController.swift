//
//  SceneViewController.swift
//  BoomR
//
//  Created by Alif Mahardhika on 05/05/21.
//
import UIKit
import SpriteKit
import GameplayKit

class SceneViewController: UIViewController, TransitionDelegate{
    var selectedLevel = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "lv" + String(selectedLevel)) {
                scene.scaleMode = .aspectFill
                scene.delegate = self as TransitionDelegate
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
//            view.ignoresSiblingOrder = true
//            view.showsFPS = true
//            view.showsNodeCount = true
        }
    }
    
    func returnToMainMenu(){
        dismiss(animated: false, completion: nil)
//        }
    }
    
    func retry(){
//        dismiss(animated: true, completion: nil)
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "lv" + String(selectedLevel)) {
                scene.scaleMode = .aspectFill
                scene.delegate = self as TransitionDelegate
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
        }
    }
    
    func nextLevel(){
        selectedLevel += 1
//        dismiss(animated: true, completion: nil)
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "lv" + String(selectedLevel)) {
                scene.scaleMode = .aspectFill
                scene.delegate = self as TransitionDelegate
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
        }
    }
}

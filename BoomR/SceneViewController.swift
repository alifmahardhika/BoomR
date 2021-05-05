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
        print("in con")
        dismiss(animated: false, completion: nil)
        
        print("GOT HERE")
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        guard  let storyboard = appDelegate.window?.rootViewController?.storyboard else { return }
//        if let vc = storyboard.instantiateInitialViewController() {
//            print("go to main menu")
//            self.present(vc, animated: true, completion: nil)
//        }
    }
    
    func retry(){
        print("in ret")
//        dismiss(animated: true, completion: nil)
        if let view = self.view as! SKView? {
        if let scene = SKScene(fileNamed: "lv" + String(selectedLevel)) {
            scene.scaleMode = .aspectFill
            scene.delegate = self as TransitionDelegate
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
        }
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        }
    }
    
    func nextLevel(){
        print("in next")
        selectedLevel += 1
//        dismiss(animated: true, completion: nil)
        if let view = self.view as! SKView? {
        if let scene = SKScene(fileNamed: "lv" + String(selectedLevel)) {
            scene.scaleMode = .aspectFill
            scene.delegate = self as TransitionDelegate
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
        }
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        }
    }
}

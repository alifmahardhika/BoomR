//
//  SelectLevelViewController.swift
//  BoomR
//
//  Created by Alif Mahardhika on 06/05/21.
//

import UIKit
import SpriteKit
import GameplayKit

class SelectLevelViewController: UIViewController{
    var selectedLevel = 1
    @IBOutlet var lvCollection: [UIButton]!
    @IBOutlet weak var lv1: UIButton!
    @IBOutlet weak var lv2: UIButton!
    @IBOutlet weak var lv3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in lvCollection {
            i.layer.cornerRadius = 5
            i.layer.borderWidth = 1
            i.layer.borderColor = UIColor.black.cgColor
        }
//        if let view = self.view as! SKView? {
//            if let scene = SKScene(fileNamed: "lv" + String(selectedLevel)) {
//                scene.scaleMode = .aspectFill
//                scene.delegate = self as TransitionDelegate
//                scene.scaleMode = .aspectFill
//                view.presentScene(scene)
//            }
//            view.ignoresSiblingOrder = true
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }
    }
    
    @IBAction func goToLevel(_ sender: UIButton) {
        print(sender.titleLabel!.text!)
        let gsStrbd: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = gsStrbd.instantiateViewController(identifier: "game") as! SceneViewController
//      present new storyboard
        vc.modalPresentationStyle = .fullScreen
        
        if let myNumber = NumberFormatter().number(from: String(sender.titleLabel!.text!.last!)) {
            let lvl = myNumber.intValue
            vc.selectedLevel = lvl
            // do what you need to do with myInt
          } else {
            fatalError("Cant determine selected level value")
            // what ever error code you need to write
          }
        
//        let lvl:Int? = Int(sender.titleLabel!.text!.last)
        
        present(vc, animated: true)
    }
}

//
//  GameViewController.swift
//  BoomR
//
//  Created by Alif Mahardhika on 30/04/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController{

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var levelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = hexStringToUIColor(hex:"#FFDC00")
        playButton.layer.cornerRadius = 5
        playButton.layer.borderWidth = 1
        playButton.layer.borderColor = UIColor.black.cgColor
//        playButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        playButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//        playButton.layer.shadowOpacity = 1.0
//        playButton.layer.shadowRadius = 0.0
//        playButton.layer.masksToBounds = false
        
        levelButton.layer.cornerRadius = 5
        levelButton.layer.borderWidth = 1
        levelButton.layer.borderColor = UIColor.black.cgColor
//        if let view = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "GameScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//                
//                
//                
//                // Present the scene
//                view.presentScene(scene)
//            }
//            
//            view.ignoresSiblingOrder = true
//            
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }
    }
    
    
    @IBAction func touchedPlay(_ sender: Any) {
        let gsStrbd: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = gsStrbd.instantiateViewController(identifier: "game") as! SceneViewController
//      present new storyboard
        vc.modalPresentationStyle = .fullScreen
        vc.selectedLevel = 1
        present(vc, animated: true)
    }
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

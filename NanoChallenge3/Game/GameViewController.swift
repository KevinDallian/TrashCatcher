//
//  GameViewController.swift
//  NanoChallenge3-tvOS
//
//  Created by Kevin Dallian on 18/07/23.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = SKView(frame: self.view.bounds)
        self.view.addSubview(skView)
        let gameScene = GameScene(size: skView.bounds.size)
        skView.presentScene(gameScene)

        // Do any additional setup after loading the view.
    }

}

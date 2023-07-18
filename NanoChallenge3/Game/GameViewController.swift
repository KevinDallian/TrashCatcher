//
//  GameViewController.swift
//  NanoChallenge3-tvOS
//
//  Created by Kevin Dallian on 18/07/23.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var gameScene : GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSKView()
        setupSwipedGestureRecognizer()
    }
    
    private func setupSKView(){
        let skView = SKView(frame: self.view.bounds)
        self.view.addSubview(skView)
        gameScene = GameScene(size: skView.bounds.size)
        skView.presentScene(gameScene)
    }
    
    func setupSwipedGestureRecognizer() {
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        leftSwipeGesture.direction = .left
        view.addGestureRecognizer(leftSwipeGesture)
    }
    
    @objc func swipedRight() {
        gameScene?.swipeRight()
    }
    
    @objc func swipedLeft() {
        gameScene?.swipeLeft()
    }

}

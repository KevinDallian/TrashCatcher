//
//  GameViewController.swift
//  NanoChallenge3-tvOS
//
//  Created by Kevin Dallian on 18/07/23.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, GameViewControllerDelegate {
    var gameScene : GameScene?
    var score = 0
    var scoreLabel : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSKView()
        setupSwipedGestureRecognizer()
        setupHUD()
    }
    
    private func setupSKView(){
        let skView = SKView(frame: self.view.bounds)
        skView.ignoresSiblingOrder = true
        self.view.addSubview(skView)
        gameScene = GameScene(size: skView.bounds.size)
        gameScene?.gameViewControllerDelegate = self
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
    
    func setupHUD(){
        scoreLabel = UILabel(frame: CGRect(x: view.bounds.maxX - 100, y: view.bounds.minY, width: 100, height: 100))
        scoreLabel?.text = String(score)
        scoreLabel?.textColor = .white
        self.view.addSubview(scoreLabel!)
    }
    
    @objc func swipedRight() {
        gameScene?.swipeRight()
    }
    
    @objc func swipedLeft() {
        gameScene?.swipeLeft()
    }
    
    func addScore() {
        score += 1
        scoreLabel?.text = String(score)
    }
    
    func startTimer() {
        //
    }

}

protocol GameViewControllerDelegate {
    func addScore()
    func startTimer()
}

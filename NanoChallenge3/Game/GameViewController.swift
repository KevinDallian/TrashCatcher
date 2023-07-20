//
//  GameViewController.swift
//  NanoChallenge3-tvOS
//
//  Created by Kevin Dallian on 18/07/23.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, ScoreDelegate, RestartDelegate {
    
    var gameScene : GameScene?
    var score = 0
    var scoreLabel : UILabel?
    
    var timeSeconds = 10
    var timer : Timer?
    var timerLabel : UILabel?
    
    var popupView : PopUpView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSKView()
        setupSwipedGestureRecognizer()
        setupHUD()
    }
    
    //MARK: SKView
    private func setupSKView(){
        let skView = SKView(frame: self.view.bounds)
        skView.ignoresSiblingOrder = true
        self.view.addSubview(skView)
        gameScene = GameScene(size: skView.bounds.size)
        gameScene?.scoreDelegate = self
        skView.presentScene(gameScene)
    }
    //MARK: SwipeGestureRecognizer
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
    
    //MARK: HUD
    func setupHUD(){
        // set scoreLabel
        scoreLabel = UILabel(frame: CGRect(x: view.bounds.maxX - 100, y: view.bounds.minY, width: 100, height: 100))
        scoreLabel?.text = String(score)
        scoreLabel?.textColor = .white
        self.view.addSubview(scoreLabel!)
        
        timerLabel = UILabel(frame: CGRect(x: view.bounds.minX + 100, y: view.bounds.minY, width: 100, height: 100))
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timerLabel?.text = "\(timeSeconds)"
        self.view.addSubview(timerLabel!)
    }
    
    //MARK: Timer
    @objc func updateTimer(){
        // Decrement the remaining seconds by 1
        timeSeconds -= 1

        // Check if the timer has reached 0 (or below) to stop the timer
        if timeSeconds <= 0 {
            stopTimer()
        }

        // Update the UI with the new remaining time
        updateTimerLabel()
    }
    
    private func stopTimer(){
        timer?.invalidate()
        timer = nil
        
        showPopup()
    }
    
    private func updateTimerLabel(){
        timerLabel?.text = "\(timeSeconds)"
    }
    
    //MARK: Popup
    private func showPopup() {
        // Create the popup view and customize it if needed
        popupView = PopUpView(frame: CGRect(x: 0, y: 0, width: 906, height: 466))
        popupView?.center = view.center
        popupView?.restartDelegate = self
        popupView?.setupScore(score: score)

        // Add the popup view as a subview to the main view
        if let popupView = popupView {
            view.addSubview(popupView)
        }
    }
    
    func resetGame() {
        score = 0
        timeSeconds = 60
        scoreLabel?.text = String(score)
        updateTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func returnToHome() {
        dismiss(animated: true, completion: nil)
    }
    
    func addScore() {
        score += 1
        scoreLabel?.text = String(score)
    }

}

//MARK: Protocols
protocol ScoreDelegate {
    func addScore()
}

protocol RestartDelegate {
    func resetGame()
    func returnToHome()
}

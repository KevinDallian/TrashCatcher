//
//  GameViewController.swift
//  NanoChallenge3-tvOS
//
//  Created by Kevin Dallian on 18/07/23.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, ScoreDelegate {
    
    var gameScene : GameScene?
    var score = 0
    var scoreLabel : UILabel?
    
    let gameDuration = 60
    var remainingSeconds = 60
    var timer : Timer?
    var timerLabel : UILabel?
    
    var popupView : PopUpView?
    let dismissButton = CustomFocusableButton().createButton(title: "New Game", fontSize: 40)
    let restartButton = CustomFocusableButton().createButton(title: "Play Again", fontSize: 40)
    
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
        timerLabel?.text = "\(remainingSeconds)"
        self.view.addSubview(timerLabel!)
    }
    
    //MARK: Timer
    @objc func updateTimer(){
        // Decrement the remaining seconds by 1
        remainingSeconds -= 1

        // Check if the timer has reached 0 (or below) to stop the timer
        if remainingSeconds <= 0 {
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
        timerLabel?.text = "\(remainingSeconds)"
    }
    
    //MARK: Popup
    private func showPopup() {
        // Create the popup view and customize it if needed
        popupView = PopUpView(frame: CGRect(x: 0, y: 0, width: 906, height: 466))
        popupView?.center = view.center
        popupView?.setupScore(score: score)
        if let popupView = popupView {
            view.addSubview(popupView)
        }
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .primaryActionTriggered)
        self.view.addSubview(dismissButton)
        restartButton.addTarget(self, action: #selector(restartButtonTapped), for: .primaryActionTriggered)
        self.view.addSubview(restartButton)
        
        NSLayoutConstraint.activate([
            // ... Existing constraints ...

            // Constraints for the dismiss button
            restartButton.topAnchor.constraint(equalTo: popupView!.bottomAnchor, constant: 20),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -150),

            // Constraints for the restart button
            dismissButton.topAnchor.constraint(equalTo: popupView!.bottomAnchor, constant: 20),
            dismissButton.leadingAnchor.constraint(equalTo: restartButton.trailingAnchor, constant: 50),
            dismissButton.bottomAnchor.constraint(equalTo: restartButton.bottomAnchor),
        ])

        // Add the popup view as a subview to the main view
        
    }
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func restartButtonTapped() {
        popupView?.removeFromSuperview()
        score = 0
        remainingSeconds = gameDuration
        scoreLabel?.text = String(score)
        updateTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        restartButton.removeFromSuperview()
        dismissButton.removeFromSuperview()
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

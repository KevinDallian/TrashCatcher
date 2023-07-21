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
    
    let gameDuration : TimeInterval = 60
    var remainingSeconds : TimeInterval = 60
    var timer : Timer?
    var timerLabel : UILabel?
    var rectangleBar: UIView!
    var rectangleBarWidthConstraint: NSLayoutConstraint!
    var widthAnimator: UIViewPropertyAnimator?
    
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
        scoreLabel = UILabel(frame: CGRect(x: view.bounds.maxX - 118, y: view.bounds.minY + 109, width: 100, height: 100))
        scoreLabel?.text = String(score)
        scoreLabel?.textColor = .white
        scoreLabel?.font = UIFont.systemFont(ofSize: 40)
        self.view.addSubview(scoreLabel!)
        
        
        let scoreCaption = UILabel(frame: CGRect(x: view.bounds.maxX - 374, y: view.bounds.minY + 109, width: 200, height: 100))
        scoreCaption.text = "Score"
        scoreCaption.textColor = .white
        scoreCaption.font = UIFont.systemFont(ofSize: 40)
        self.view.addSubview(scoreCaption)
        
        let highScoreCaption = UILabel(frame: CGRect(x: view.bounds.maxX - 374, y: view.bounds.minY + 62, width: 200, height: 100))
        highScoreCaption.text = "Highest Score"
        highScoreCaption.textColor = UIColor(named: "Gray")
        highScoreCaption.font = UIFont.systemFont(ofSize: 24)
        self.view.addSubview(highScoreCaption)
        
        let highScoreLabel = UILabel(frame: CGRect(x: view.bounds.maxX - 118, y: view.bounds.minY + 62, width: 100, height: 100))
        highScoreLabel.text = String(UserDefaults.standard.integer(forKey: "highscore"))
        highScoreLabel.textColor = UIColor(named: "Gray")
        highScoreLabel.font = UIFont.systemFont(ofSize: 24)
        self.view.addSubview(highScoreLabel)
        
        //MARK: RectangleBar
        rectangleBar = UIView()
        rectangleBar.backgroundColor = .systemYellow // Set the color of the rectangle bar
        rectangleBar.translatesAutoresizingMaskIntoConstraints = false
        rectangleBar.layer.cornerRadius = 10
        let grayBar = UIView()
        grayBar.backgroundColor = UIColor(named: "Gray")
        grayBar.translatesAutoresizingMaskIntoConstraints = false
        grayBar.layer.cornerRadius = 10
        view.addSubview(grayBar)
        view.addSubview(rectangleBar)
    
        rectangleBarWidthConstraint = rectangleBar.widthAnchor.constraint(equalToConstant: 400)
        rectangleBarWidthConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            rectangleBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 68),
            rectangleBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            rectangleBar.heightAnchor.constraint(equalToConstant: 40),
            
            grayBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 68),
            grayBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            grayBar.heightAnchor.constraint(equalToConstant: 40),
            grayBar.widthAnchor.constraint(equalToConstant: 400)
        ])
        
        timerLabel = UILabel(frame: CGRect(x: view.bounds.minX + 398, y: view.bounds.minY + 60, width: 100, height: 100))
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timerLabel?.text = String(format: "0:%.0f", remainingSeconds)
        timerLabel?.font = UIFont.systemFont(ofSize: 25)
        timerLabel?.textColor = .black
        self.view.addSubview(timerLabel!)
        
        
    }
    
    //MARK: Timer
    @objc func updateTimer(){
        // Decrement the remaining seconds by 1
        remainingSeconds -= 1

        // Check if the timer has reached 0 (or below) to stop the timer
        if remainingSeconds <= 0 {
            widthAnimator?.stopAnimation(true)
            stopTimer()
        }
        
        let progress = remainingSeconds / gameDuration // Calculate the progress from 1.0 to 0

        // Update the width constraint of the rectangle bar based on the progress
        rectangleBarWidthConstraint.constant = progress * 400
        widthAnimator = UIViewPropertyAnimator(duration: 1.0, curve: .linear, animations: {
            self.view.layoutIfNeeded()
        })
        widthAnimator?.startAnimation()
        // Update the UI with the new remaining time
        updateTimerLabel()
    }
    
    private func stopTimer(){
        
        timer?.invalidate()
        timer = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showPopup()
        }
        
    }
    
    private func updateTimerLabel(){
        timerLabel?.text = String(format: "0:%.0f", remainingSeconds)
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
    
    //MARK: Buttons
    
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

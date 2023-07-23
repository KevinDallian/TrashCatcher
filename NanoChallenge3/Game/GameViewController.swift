//
//  GameViewController.swift
//  NanoChallenge3-tvOS
//
//  Created by Kevin Dallian on 18/07/23.
//

import UIKit
import SpriteKit
import AVFoundation
import Combine
import DeviceDiscoveryUI
import Lottie

class GameViewController: UIViewController, ScoreDelegate {
    //MARK: Gameplay Variables
    var gameScene : GameScene?
    var score = 0
    var scoreLabel : UILabel?
    var highScoreLabel : UILabel?
    var popupView : PopUpView?
    let dismissButton = CustomFocusableButton().createButton(title: "New Game", fontSize: 40)
    let restartButton = CustomFocusableButton().createButton(title: "Play Again", fontSize: 40)
    
    //MARK: Timer Variable
    let gameDuration : TimeInterval = 5
    var remainingSeconds : TimeInterval = 5
    var timer : Timer?
    var timerLabel : UILabel?
    var rectangleBar: UIView!
    var rectangleBarWidthConstraint: NSLayoutConstraint!
    var widthAnimator: UIViewPropertyAnimator?
    var positionPoint : Float!
    
    var localDeviceManager = LocalDeviceManager(applicationService: "trashCatcher", didReceiveMessage: { data in
        guard let string = String(data: data, encoding: .utf8) else { return }
    }, errorHandler: { error in
        NSLog("ERROR: \(error)")
    })
    
    
    private let personImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "person"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let animationView = LottieAnimationView(name: "ArrowMotionOnboarding")

    //Audio
    var audioManager = AudioManager.shared
//    var audioPlayerBackground: AVAudioPlayer?
//    var audioPlayer: AVAudioPlayer?
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        connectIOS()
        localDeviceManager.didReceiveMessage = messageReceivedFromManager(_:)
        audioManager.setupAudio(resourceName: "Item Collected", audioType: .soundtrack, ofType: "mp3", shouldLoop: false, volume: 0.1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !audioManager.isMuted {
            audioManager.setupAudio(resourceName: "Gameplay", audioType: .background, ofType: "mp3", shouldLoop: true, volume: 0.1)
            audioManager.playSound(audioType: .background)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        gameScene?.stopLoopSpawnGarbage()
        audioManager.stopBackground()
        gameScene = nil
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
        let whiteBackground = UIView()
          whiteBackground.backgroundColor = UIColor.white.withAlphaComponent(0.3)
          whiteBackground.translatesAutoresizingMaskIntoConstraints = false
          whiteBackground.layer.cornerRadius = 24
          view.addSubview(whiteBackground)

   
        NSLayoutConstraint.activate([
            whiteBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            whiteBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: 68),
            whiteBackground.widthAnchor.constraint(equalToConstant: 397),
            whiteBackground.heightAnchor.constraint(equalToConstant: 141)
        ])
        
        let fontName = "BubblegumSans-Regular"
        scoreLabel = UILabel(frame: CGRect(x: view.bounds.maxX - 118, y: view.bounds.minY + 109, width: 100, height: 100))
        scoreLabel?.text = String(score)
        scoreLabel?.textColor = .black
        scoreLabel?.font = UIFont(name: fontName, size: 40) ?? .systemFont(ofSize: 40)
        self.view.addSubview(scoreLabel!)
        
        //MARK: Score
        let scoreCaption = UILabel(frame: CGRect(x: view.bounds.maxX - 374, y: view.bounds.minY + 109, width: 200, height: 100))
        scoreCaption.text = "Score"
        scoreCaption.textColor = .black
        scoreCaption.font = UIFont(name: fontName, size: 40) ?? .systemFont(ofSize: 40)
        self.view.addSubview(scoreCaption)
        
        let highScoreCaption = UILabel(frame: CGRect(x: view.bounds.maxX - 374, y: view.bounds.minY + 62, width: 200, height: 100))
        highScoreCaption.text = "Highest Score"
        highScoreCaption.textColor = .black.withAlphaComponent(0.5)
        highScoreCaption.font = UIFont(name: fontName, size: 24) ?? .systemFont(ofSize: 24)
        self.view.addSubview(highScoreCaption)
        
        highScoreLabel = UILabel(frame: CGRect(x: view.bounds.maxX - 118, y: view.bounds.minY + 62, width: 100, height: 100))
        highScoreLabel?.text = String(UserDefaults.standard.integer(forKey: "highscore"))
        highScoreLabel?.textColor = .black.withAlphaComponent(0.5)
        highScoreLabel?.font = UIFont(name: fontName, size: 24) ?? .systemFont(ofSize: 24)
        self.view.addSubview(highScoreLabel!)
        
        //MARK: RectangleBar
        rectangleBar = UIView()
        rectangleBar.backgroundColor = .systemGreen // Set the color of the rectangle bar
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
        
        //MARK: Timer
       
        let timerCaption = UILabel(frame: CGRect(x: view.bounds.minX + 64, y: view.bounds.minY + 10, width: 200, height: 100))
        
        timerCaption.text = "Timer"
        timerCaption.textColor = .black
        timerCaption.font =  UIFont(name: fontName, size: 40) ?? .systemFont(ofSize: 40)
        
        self.view.addSubview(timerCaption)
        timerLabel = UILabel(frame: CGRect(x: view.bounds.minX + 398, y: view.bounds.minY + 60, width: 100, height: 100))
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timerLabel?.text = String(format: "0:%.0f", remainingSeconds)
        timerLabel?.font = UIFont(name: fontName, size: 25) ?? .systemFont(ofSize: 50)
        timerLabel?.textColor = .black
        self.view.addSubview(timerLabel!)
        
        
    }
    //MARK: Timer Functions
    @objc func updateTimer(){
        // Decrement the remaining seconds by 1
        remainingSeconds -= 1
        
        // Check if the timer has reached 0 (or below) to stop the timer
        if remainingSeconds <= 0 {
            widthAnimator?.stopAnimation(true)
            stopTimer()
        }else if remainingSeconds <= 10 {
            rectangleBar.backgroundColor = .systemRed
        }else if remainingSeconds <= 30 {
            rectangleBar.backgroundColor = .systemYellow
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
        audioManager.setupAudio(resourceName: "Game End", audioType: .soundtrack, ofType: "mp3", shouldLoop: false, volume: 0.2)
        
        if !audioManager.isMuted {
            audioManager.pauseBackground()
            audioManager.playSound(audioType: .soundtrack)
           
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.audioManager.playSound(audioType: .background)
        }
        
        
        gameScene?.stopLoopSpawnGarbage()
        popupView = PopUpView(frame: CGRect(x: 0, y: 0, width: 1092, height: 538))
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
            popupView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            restartButton.topAnchor.constraint(equalTo: popupView!.bottomAnchor, constant: 20),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -150),
            restartButton.widthAnchor.constraint(equalToConstant: 300),
            restartButton.heightAnchor.constraint(equalToConstant: 100),
            
            dismissButton.topAnchor.constraint(equalTo: popupView!.bottomAnchor, constant: 20),
            dismissButton.leadingAnchor.constraint(equalTo: restartButton.trailingAnchor, constant: 50),
            dismissButton.bottomAnchor.constraint(equalTo: restartButton.bottomAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 100),
            dismissButton.widthAnchor.constraint(equalToConstant: 300)
            
        ])
        
        
    }
    
    //MARK: Buttons
    @objc private func dismissButtonTapped() {
        // Play the "Button click" audio
//        setupAudio(resourceName: "Button Click", ofType: "mp3", shouldLoop: false, volume: 1.0)
//        audioPlayer?.play()
        if !audioManager.isMuted {
            audioManager.setupAudio(resourceName: "Button Click", audioType: .soundtrack, ofType: "mp3", shouldLoop: false, volume: 1.0)
            audioManager.playSound(audioType: .soundtrack)
        }

        highScoreLabel?.text = String(UserDefaults.standard.integer(forKey: "highscore"))
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func restartButtonTapped() {
        // Play the "Button click" audio
        if !audioManager.isMuted {
            audioManager.setupAudio(resourceName: "Button Click", audioType: .soundtrack, ofType: "mp3", shouldLoop: false, volume: 1.0)
            audioManager.playSound(audioType: .soundtrack)
        }
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
        if !audioManager.isMuted {
            audioManager.pauseBackground()
            audioManager.playSound(audioType: .soundtrack)
        }
        
        score += 1
        scoreLabel?.text = String(score)
        
        if !audioManager.isMuted{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                self.audioManager.playSound(audioType: .background)
            }
        }
    }
    //MARK: Overlay
    func setupPersonImageView() {
        view.addSubview(personImageView)
        
        NSLayoutConstraint.activate([
            personImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            personImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            personImageView.widthAnchor.constraint(equalToConstant: 657),
            personImageView.heightAnchor.constraint(equalToConstant: 640)
        ])
    }
    
    func setupArrow(){
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            animationView.widthAnchor.constraint(equalToConstant: 657),
            animationView.heightAnchor.constraint(equalToConstant: 640)
        ])
    }
    
    func hidePersonAndArrowImageViewAfterDelay(_ delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.5, animations: {
                self.personImageView.alpha = 0.0 // Set alpha to 0 to hide the image
                self.animationView.alpha = 0.0
            }) { (_) in
                self.personImageView.removeFromSuperview() // Remove the imageView from its superview
                self.animationView.removeFromSuperview()
            }
        }
    }
    
    //MARK: DeviceDiscoveryUI
    func connectIOS() async {
        let parameters = NWParameters.applicationService
                
        // Create the view controller for the endpoint picker.
        if let devicePickerController =
            DDDevicePickerViewController(browseDescriptor: NWBrowser.Descriptor.applicationService(name: "trashCatcher"), parameters: parameters){

            // Show the network device picker as a full-screen, modal view.
            devicePickerController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            present(devicePickerController, animated: true, completion: nil)
            
            let endpoint: NWEndpoint
            do {
                endpoint = try await devicePickerController.endpoint
            } catch {
                // The user canceled the endpoint picker view.
                return
            }
            localDeviceManager.connect(to: endpoint)
            setupSpriteKit()
        } else {
        }
    }
    
    func connectIOS() {
        Task {
            await connectIOS()
        }
    }
    
    func messageReceivedFromManager(_ data: Data) {
        let message = String(data: data, encoding: .utf8)
        
        if let floatValue = Float(message!) {
            gameScene?.moveBinNode(xPosition: scaleValue(CGFloat(floatValue), fromRangeMin: 40, fromRangeMax: 800, toRangeMin: 0, toRangeMax: 1920))
            print("\(floatValue)")
        }else{ // Pinch
//            print("Pinched")
        }
    }
    // MARK: SetupSpriteKit
    func setupSpriteKit(){
        setupSKView()
        setupSwipedGestureRecognizer()
        setupHUD()
        setupPersonImageView()
        setupArrow()
        hidePersonAndArrowImageViewAfterDelay(3.0)
        
    }
    
    func scaleValue(_ value: CGFloat, fromRangeMin: CGFloat, fromRangeMax: CGFloat, toRangeMin: CGFloat, toRangeMax: CGFloat) -> CGFloat {
        // Ensure the value is within the fromRange limits
        let clampedValue = min(max(value, fromRangeMin), fromRangeMax)

        // Calculate the scaled value
        let fromRange = fromRangeMax - fromRangeMin
        let toRange = toRangeMax - toRangeMin
        let scaledValue = toRangeMin + ((clampedValue - fromRangeMin) / fromRange) * toRange

        return scaledValue
    }
}

//MARK: Protocols
protocol ScoreDelegate {
    func addScore()
}

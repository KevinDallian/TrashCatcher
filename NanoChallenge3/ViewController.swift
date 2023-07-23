//
//  ViewController.swift
//  NanoChallenge3
//
//  Created by Kevin Dallian on 17/07/23.
//


import UIKit
import AVFoundation

class ViewController: UIViewController {

    private var logoImageView: UIImageView!
    private var textRaiseHand: UILabel!
    private var playButton: UIButton!
    let startButton = CustomFocusableButton().createButton(title: "Start Game", fontSize: 40)
    var soundButton = CustomFocusableButton().createButton(title: "sound_on" , fontSize: 40)
    var audioPlayer: AVAudioPlayer?
    var isSoundOn = true

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
        setupSoundButton()
        setupLabel()
        setupStartBtn()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAudio(resourceName: "Start Menu", ofType: "mp3", shouldLoop: true, volume: 0.5)
        // Check if the audio player is available and play the audio
//        if let player = audioPlayer {
//            player.play()
//        }
    }

    func setupAudio(resourceName:String, ofType:String, shouldLoop:Bool, volume:Float){
        audioPlayer = AVAudioPlayer.setupAudioPlayer(resourceName: resourceName, ofType: ofType, shouldLoop: shouldLoop, volume: volume)
    }


    func setupBackground() {
        let backgroundImage = UIImage(named: "background-start")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.bounds
        view.addSubview(backgroundImageView)

        soundButton.addTarget(self, action: #selector(soundButtonTapped), for: .primaryActionTriggered)
        self.view.addSubview(soundButton)

        NSLayoutConstraint.activate([
            soundButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                       soundButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            soundButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            soundButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            soundButton.widthAnchor.constraint(equalToConstant: 106),
            soundButton.heightAnchor.constraint(equalToConstant: 106)
        ])
    }

    func setupLogo() {
        let logoImage = UIImage(named: "Logo")
        logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            logoImageView.widthAnchor.constraint(equalToConstant: 658),
            logoImageView.heightAnchor.constraint(equalToConstant: 306)
        ])
    }

    func setupLabel() {
        let fontName = "BubblegumSans-Regular"
        textRaiseHand = UILabel()
        textRaiseHand.text = "Raise hand to start"
        textRaiseHand.textColor = .white
        textRaiseHand.textAlignment = .center
        textRaiseHand.font = UIFont(name: fontName, size: 40)
        textRaiseHand.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textRaiseHand)

        NSLayoutConstraint.activate([
            textRaiseHand.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textRaiseHand.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 260),
            textRaiseHand.widthAnchor.constraint(equalToConstant: 552),
            textRaiseHand.heightAnchor.constraint(equalToConstant: 53),
        ])
    }

    func setupStartBtn(){
        startButton.addTarget(self, action: #selector(didTapButton), for: .primaryActionTriggered)
        self.view.addSubview(startButton)

        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: textRaiseHand.bottomAnchor, constant: 60),
            startButton.widthAnchor.constraint(equalToConstant: 300),
            startButton.heightAnchor.constraint(equalToConstant: 100),
        ])

        //Shadow Button
        startButton.layer.cornerRadius = 32
        startButton.layer.shadowColor = UIColor.black.cgColor
        startButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        startButton.layer.shadowOpacity = 0.5
        startButton.layer.shadowRadius = 4
    }

    @objc func didTapButton() {

        // Play the "Button click" audio
        setupAudio(resourceName: "Button Click", ofType: "mp3", shouldLoop: false, volume: 1.0)
        audioPlayer?.play()
        let nextViewController = GameViewController()
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: true, completion: nil)


    }

    func setupSoundButton() {
        soundButton.addTarget(self, action: #selector(soundButtonTapped), for: .primaryActionTriggered)
        self.view.addSubview(soundButton)

        NSLayoutConstraint.activate([
            soundButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            soundButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            soundButton.widthAnchor.constraint(equalToConstant: 106),
            soundButton.heightAnchor.constraint(equalToConstant: 106)
        ])

        }

        @objc func soundButtonTapped() {
            isSoundOn = !isSoundOn
            let newImageName = isSoundOn ? "sound_on" : "sound_off"
            soundButton.setBackgroundImage(UIImage(named: newImageName), for: .normal)

            // Perform any actions you want when the button is tapped, for example, play or pause sound
            if isSoundOn {
                // Play the sound
            } else {
                // Pause or stop the sound
            }
        }

    func attributedStringWithStroke(text: String, strokeWidth: Float, strokeColor: UIColor, fillColor: UIColor, font: UIFont, letterSpacing: CGFloat, lineHeight: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight - font.lineHeight
        paragraphStyle.alignment = .center // Set the text alignment as needed

        let strokeAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: strokeColor,
            .strokeWidth: -strokeWidth,
            .foregroundColor: fillColor,
            .font: font,
            .kern: letterSpacing,
            .paragraphStyle: paragraphStyle // Set the paragraph style with line height
        ]

        let attributedString = NSMutableAttributedString(string: text, attributes: strokeAttributes)
        return attributedString
    }


}
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cleanedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if cleanedHex.count == 3 {
            cleanedHex = cleanedHex.map { "\($0)\($0)" }.joined()
        }
        let scanner = Scanner(string: cleanedHex)
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Int(color >> 16) & mask) / 255.0
        let g = CGFloat(Int(color >> 8) & mask) / 255.0
        let b = CGFloat(Int(color) & mask) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

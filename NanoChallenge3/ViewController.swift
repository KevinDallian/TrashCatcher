//
//  ViewController.swift
//  NanoChallenge3
//
//  Created by Kevin Dallian on 17/07/23.
//


import UIKit

class ViewController: UIViewController {
    
    private var logoImageView: UIImageView!
    private var textRaiseHand: UILabel!
    private var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupLabel()
        setupStartButton()
    }
    
    func setupBackground() {
        let backgroundImage = UIImage(named: "background-start")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.bounds
        view.addSubview(backgroundImageView)
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
    
    func setupStartButton() {
        
        playButton = UIButton(type: .custom)
        //        playButton.setImage(UIImage(named: "buttonImage"), for: .normal)
        let text = "Start Game"
        let fontName = "BubblegumSans-Regular"
        let strokeWidth: Float = 4.0
        let strokeColor = UIColor(hex: "#464646")
        let fillColor: UIColor = .white
        let font: UIFont = UIFont(name: fontName, size: 50) ?? .systemFont(ofSize: 50)
        let letterSpacing: CGFloat = 0.0
        let attributedTitle = attributedStringWithStroke(text: text, strokeWidth: strokeWidth, strokeColor: strokeColor, fillColor: fillColor, font: font, letterSpacing: letterSpacing, lineHeight: 64)
        
        playButton.setAttributedTitle(attributedTitle, for: .normal)
        playButton.backgroundColor =  UIColor(hex: "#EF9180")
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(didTapButton), for: .primaryActionTriggered)
        
        self.view.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: textRaiseHand.bottomAnchor, constant: 60),
            playButton.widthAnchor.constraint(equalToConstant: 300),
            playButton.heightAnchor.constraint(equalToConstant: 100),
        ])
        //Shadow Button
        playButton.layer.cornerRadius = 32
        playButton.layer.shadowColor = UIColor.black.cgColor
        playButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        playButton.layer.shadowOpacity = 0.5
        playButton.layer.shadowRadius = 4
        
    }
    
    @objc func didTapButton() {
        let nextViewController = GameViewController()
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: true, completion: nil)
        
    }
    
//    func attributedStringWithStroke(text: String, strokeWidth: Float, strokeColor: UIColor, fillColor: UIColor, font: UIFont, letterSpacing: CGFloat) -> NSAttributedString {
//        let strokeAttributes: [NSAttributedString.Key: Any] = [
//            .strokeColor: strokeColor,
//            .strokeWidth: -strokeWidth, // Use a negative value to apply stroke inside the text
//            .foregroundColor: fillColor,
//            .font: font,
//            .kern: letterSpacing
//        ]
//
//        let attributedString = NSMutableAttributedString(string: text, attributes: strokeAttributes)
//        return attributedString
//    }
//
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

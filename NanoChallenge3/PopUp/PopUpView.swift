//
//  PopUpView.swift
//  NanoChallenge3-tvOS
//
//  Created by Kevin Dallian on 20/07/23.
//

import UIKit
import SpriteKit
//MARK: PopUp View
class PopUpView: UIView {
    
    var score = 0
    
    private let scoreLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let backgroundImage = UIImage(named: "popupbackground")
        let background = UIImageView(frame: CGRect(x: bounds.minX, y: bounds.minY - 55, width: 1092, height: 650))
        background.image = backgroundImage
        addSubview(background)
        
        addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
//    func setupScore(score: Int){
//        let fontName = "BubblegumSans-Regular"
//        self.score = score
//        scoreLabel.text = String(score)
//        scoreLabel.font = UIFont(name: fontName, size: 40) ?? .systemFont(ofSize: 40)
//
//        let strokeWidth: Float = 4.0
//        let strokeColor = UIColor(hex: "#464646")
//        let fillColor: UIColor =  UIColor(hex: "#EF9180")
//        let font: UIFont = UIFont(name: fontName, size: 50)!
//        let letterSpacing: CGFloat = 0.0
//        let attributedTitle = attributedStringWithStroke(text: scoreLabel.text!, strokeWidth: strokeWidth, strokeColor: strokeColor, fillColor: fillColor, font: font, letterSpacing: letterSpacing, lineHeight: 64)
//
//
//
//        let userDefaultsScore = UserDefaults.standard.integer(forKey: "highscore")
//        if userDefaultsScore < score {
//            UserDefaults.standard.set(score, forKey: "highscore")
//        }
//        
//    }
//
    func setupScore(score: Int) {
        let fontName = "BubblegumSans-Regular"
        self.score = score
        scoreLabel.text = String(score)
        scoreLabel.font = UIFont(name: fontName, size: 40) ?? .systemFont(ofSize: 40)

        let strokeWidth: Float = 5.0
        let strokeColor = UIColor(hex: "#464646")
        let fillColor: UIColor =  UIColor(hex: "#EF9180")
        let font: UIFont = UIFont(name: fontName, size: 96)!
        let letterSpacing: CGFloat = 0.0
        let lineHeight: CGFloat = 64.0 // Set the desired line height

        // Create the attributed string with the desired attributes
        let attributedTitle = attributedStringWithStroke(text: scoreLabel.text!,
                                                         strokeWidth: strokeWidth,
                                                         strokeColor: strokeColor,
                                                         fillColor: fillColor,
                                                         font: font,
                                                         letterSpacing: letterSpacing,
                                                         lineHeight: lineHeight)

        // Set the attributed text to the scoreLabel
        scoreLabel.attributedText = attributedTitle

        let userDefaultsScore = UserDefaults.standard.integer(forKey: "highscore")
        if userDefaultsScore < score {
            UserDefaults.standard.set(score, forKey: "highscore")
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

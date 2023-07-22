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
    
    func setupScore(score: Int){
        self.score = score
        scoreLabel.text = String(score)
        let userDefaultsScore = UserDefaults.standard.integer(forKey: "highscore")
        if userDefaultsScore < score {
            UserDefaults.standard.set(score, forKey: "highscore")
        }
        
    }
}

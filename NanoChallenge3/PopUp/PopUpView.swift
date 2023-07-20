//
//  PopUpView.swift
//  NanoChallenge3-tvOS
//
//  Created by Kevin Dallian on 20/07/23.
//

import UIKit
import SpriteKit

class PopUpView: UIView {
    
    var restartDelegate : RestartDelegate?
    var score = 0
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Congratulations!"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 48)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dismissButton: CustomFocusableButton = {
        let button = CustomFocusableButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .primaryActionTriggered)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let captionLabel : UILabel = {
        let label = UILabel()
        label.text = "Your Score"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scoreLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let restartButton: CustomFocusableButton = {
        let button = CustomFocusableButton(type: .system)
        button.setTitle("Restart", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(restartButtonTapped), for: .primaryActionTriggered)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)
        
        
        addSubview(titleLabel)
        addSubview(dismissButton)
        addSubview(restartButton)
        addSubview(captionLabel)
        addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            captionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            captionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            
            scoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            scoreLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 15),
            
            dismissButton.centerXAnchor.constraint(equalTo: centerXAnchor),  // Center vertically
            dismissButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            
            restartButton.centerXAnchor.constraint(equalTo: centerXAnchor), // Center horizontally
            restartButton.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 20), // Position below dismissButton with 20 points spacing
            restartButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20), // Optional: Set a maximum bottom constraint to avoid overlapping with the bottom edge
        ])
    }
    
    @objc private func dismissButtonTapped() {
        restartDelegate?.returnToHome()
    }
    
    @objc private func restartButtonTapped() {
        removeFromSuperview()
        restartDelegate?.resetGame()
    }
    
    func setupScore(score: Int){
        self.score = score
        scoreLabel.text = String(score)
    }
    
    
}

//
//  CustomFocusableButton.swift
//  NanoChallenge3-tvOS
//
//  Created by Kevin Dallian on 20/07/23.
//

import Foundation
import UIKit

class CustomFocusableButton : UIButton {
    override var canBecomeFocused: Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
               
       // Customize the appearance based on the focus state
        if isFocused {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        if context.nextFocusedView == self {
            // Button is about to gain focus (highlighted)
            // Remove the focus effect by modifying its appearance
            self.layer.shadowOpacity = 0.0 // Remove the white inner shadow
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) // Remove the enlargement
            self.layer.cornerRadius = 10
        } else if context.previouslyFocusedView == self {
            // Button is about to lose focus (unhighlighted)
            // Reset the appearance to the default focus effect
            self.layer.shadowOpacity = 0.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    convenience init() {
        self.init(type: .system)
        self.backgroundColor = .clear
    }
    
}

extension CustomFocusableButton {
    func createButton(title: String, fontSize: Int) -> CustomFocusableButton {
        let button = CustomFocusableButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(fontSize))
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "buttonbackground"), for: .normal)
        button.setBackgroundImage(UIImage(named: "buttonbackgroundfocused"), for: .focused)
        button.adjustsImageWhenDisabled = false
        button.adjustsImageWhenHighlighted = false
        button.contentMode = .scaleAspectFill
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

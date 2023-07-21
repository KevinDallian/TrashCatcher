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
        
    }
    
}

extension CustomFocusableButton {
    func createButton(title: String, fontSize: Int) -> CustomFocusableButton {
        let button = CustomFocusableButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(fontSize))
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(nil, for: .normal)
        button.setBackgroundImage(nil, for: .focused)
        button.setBackgroundImage(nil, for: .highlighted)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

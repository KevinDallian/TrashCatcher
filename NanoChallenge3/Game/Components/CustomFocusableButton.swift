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
        if isFocused {
            // Set the focused background color when the button is selected
            self.backgroundColor = .systemPink
        } else {
            // Set the default background color when the button is not selected
            self.backgroundColor = .systemPink
        }
    }
}

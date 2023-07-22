//
//  HoverButton.swift
//  NanoChallenge3-tvOS
//
//  Created by Muhammad Athif on 23/07/23.
//

import Foundation
import UIKit
class HoverButton: UIButton {
    override var canBecomeFocused: Bool {
        return true
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.isFocused {
            print("focused")
            // Apply shadow when the button is focused
            self.layer.shadowColor = UIColor.red.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 8)
            self.layer.shadowOpacity = 0.5
            self.layer.shadowRadius = 8
        } else {
            print("tidak focused")
            // Remove shadow when the button loses focus
            self.layer.shadowOpacity = 0
        }
    }
}

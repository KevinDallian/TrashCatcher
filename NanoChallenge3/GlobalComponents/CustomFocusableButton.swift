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
    }
    
    convenience init() {
        self.init(type: .system)
        self.backgroundColor = .clear
    }
    
}

extension CustomFocusableButton {
    func createButton(title: String, fontSize: Int) -> CustomFocusableButton {
        let button = CustomFocusableButton(type: .custom)
        if title == "New Game"{
            button.setBackgroundImage(UIImage(named: "newgame"), for: .normal)
            button.setBackgroundImage(UIImage(named: "newgamefocused"), for: .focused)
        }else if title == "Start Game"{
            button.setBackgroundImage(UIImage(named: "startgame"), for: .normal)
            button.setBackgroundImage(UIImage(named: "startgamefocused"), for: .focused)
        }else if title == "sound_on"{
            button.setBackgroundImage(UIImage(named: "soundon"), for: .normal)
            button.setBackgroundImage(UIImage(named: "soundonfocussed"), for: .focused)
        }
        else if title == "sound_off"{
            button.setBackgroundImage(UIImage(named: "soundoff"), for: .normal)
            button.setBackgroundImage(UIImage(named: "soundoffocussed"), for: .focused)
        }
        else {
            button.setBackgroundImage(UIImage(named: "playagain"), for: .normal)
            button.setBackgroundImage(UIImage(named: "playagainfocused"), for: .focused)
        }
        button.contentMode = .scaleAspectFit
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

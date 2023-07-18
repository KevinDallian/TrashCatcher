//
//  GameScene.swift
//  NanoChallenge3-tvOS
//
//  Created by Kevin Dallian on 18/07/23.
//

import Foundation
import SpriteKit
import UIKit

class GameScene : SKScene{
    override func didMove(to view: SKView) {
        setupBackground(to: view)
    }
    
    private func setupBackground(to view: SKView){
        let tvScreenSize = view.bounds.size
        let sceneAspectRatio = CGSize(width: 16, height: 9)
        
        let widthRatio = tvScreenSize.width / sceneAspectRatio.width
        let heightRatio = tvScreenSize.height / sceneAspectRatio.height
        let scale = min(widthRatio, heightRatio)
        
        let scaledSize = CGSize(width: sceneAspectRatio.width * scale, height: sceneAspectRatio.height * scale)
        self.size = scaledSize
        self.backgroundColor = .systemPink
    }
    
}

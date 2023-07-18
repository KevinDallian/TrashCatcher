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
    let binNode = BinNode()
    override func didMove(to view: SKView) {
        setupBackground(to: view)
        setupBin()
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
    
    private func setupBin(){
        binNode.position = CGPoint(x: frame.midX, y: frame.minY)
        addChild(binNode)
    }
    
    public func swipeLeft(){
        let moveLeftAction = SKAction.move(to: CGPoint(x: binNode.position.x - 200, y: binNode.position.y), duration: 0.2)
        binNode.run(moveLeftAction)
    }
    
    public func swipeRight(){
        let moveRightAction = SKAction.move(to: CGPoint(x: binNode.position.x + 200, y: binNode.position.y), duration: 0.2)
        binNode.run(moveRightAction)
    }
    
}

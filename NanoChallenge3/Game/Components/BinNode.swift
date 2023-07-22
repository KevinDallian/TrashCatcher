//
//  Bin.swift
//  NanoChallenge3-tvOS
//
//  Created by Kevin Dallian on 18/07/23.
//

import Foundation
import SpriteKit

class BinNode : SKSpriteNode {
    let imageUrl = "character1"
    
    init(){
        let imageTexture = SKTexture(imageNamed: "\(imageUrl)-right")
        let binNodeSize = CGSize(width: imageTexture.size().width - 50, height: imageTexture.size().height - 100)
        super.init(texture: imageTexture, color: .clear, size: binNodeSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum CharacterPosition {
    case right
    case left
}

func switchCharacterPosition(characterPosition: CharacterPosition, character: String) -> String{
    switch characterPosition{
    case .right:
        return "\(character)-left"
    case .left:
        return "\(character)-right"
    }

}



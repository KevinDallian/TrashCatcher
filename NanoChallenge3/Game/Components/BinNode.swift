//
//  Bin.swift
//  NanoChallenge3-tvOS
//
//  Created by Kevin Dallian on 18/07/23.
//

import Foundation
import SpriteKit

class BinNode : SKSpriteNode {
    let imageUrl = "garbage"
    
    init(){
        let binNode = SKSpriteNode(imageNamed: imageUrl)
        let binNodeSize = CGSize(width: 100, height: 100)
        binNode.size = binNodeSize
        binNode.anchorPoint = CGPoint(x: 0.5, y: 0)
        super.init(texture: nil, color: .clear, size: binNodeSize)
        addChild(binNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



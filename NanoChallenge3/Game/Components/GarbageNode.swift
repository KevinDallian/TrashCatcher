//
//  GarbageNode.swift
//  NanoChallenge3-tvOS
//
//  Created by Kevin Dallian on 19/07/23.
//

import Foundation
import SpriteKit

class GarbageNode : SKSpriteNode {
    let imageUrl = "garbagepaper"
    
    init(){
        let garbageNode = SKSpriteNode(imageNamed: imageUrl)
        let garbageNodeSize = CGSize(width: 50, height: 50)
        garbageNode.size = garbageNodeSize
        garbageNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // add gravity
        garbageNode.physicsBody = SKPhysicsBody(circleOfRadius: garbageNode.size.width / 2)
        garbageNode.physicsBody?.affectedByGravity = true
        garbageNode.physicsBody?.mass = 1.0 // Adjust the mass as desired
        garbageNode.physicsBody?.restitution = 0.5 // Adjust the restitution (bounciness) as desired
        garbageNode.physicsBody?.friction = 0.2 // Adjust the friction as desired

        
        super.init(texture: nil, color: .clear, size: garbageNodeSize)
        addChild(garbageNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

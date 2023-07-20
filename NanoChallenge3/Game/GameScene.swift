//
//  GameScene.swift
//  NanoChallenge3-tvOS
//
//  Created by Kevin Dallian on 18/07/23.
//

import Foundation
import SpriteKit
import UIKit

class GameScene : SKScene, SKPhysicsContactDelegate{
    let binNode = BinNode()
    // Constant for moving binNode
    let movePoints = 180.0
    
    var gameViewControllerDelegate : GameViewControllerDelegate?
    
    override func didMove(to view: SKView) {
        // gravity and detect collision
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        setupBackground(to: view)
        setupBin()
        loopSpawnGarbage()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Check if binNode and garbageNode collide
        if (contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2) ||
           (contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1) {
            // Collision detected between binNode and garbageNode
            // Handle adding score points and removing garbageNode here
            handleCollision(contact)
        }
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
        binNode.physicsBody = SKPhysicsBody(rectangleOf: binNode.size)
        binNode.physicsBody?.isDynamic = false
        
        binNode.physicsBody?.categoryBitMask = 1 // Set a unique bit mask for binNode
        binNode.physicsBody?.collisionBitMask = 0 // No collision with other physics bodies
        binNode.physicsBody?.contactTestBitMask = 2 // Contact will be detected with bit mask 2 (garbageNodea)
        addChild(binNode)
    }
    
    private func spawnGarbage(){
        let garbage = GarbageNode()
        let randomXPosition = CGFloat.random(in: frame.minX..<frame.maxX)
        garbage.position = CGPoint(x: frame.midX, y: frame.maxY)
        garbage.physicsBody = SKPhysicsBody(rectangleOf: garbage.size)
        garbage.physicsBody?.isDynamic = true
        
        garbage.physicsBody?.categoryBitMask = 2 // Set a unique bit mask for garbageNode
        garbage.physicsBody?.collisionBitMask = 0 // No collision with other physics bodies
        garbage.physicsBody?.contactTestBitMask = 1 // Contact will be detected with bit mask 1 (binNode)
        addChild(garbage)
    }
    
    private func loopSpawnGarbage(){
        let spawnAction = SKAction.run {
            self.spawnGarbage()
        }
        let delayAction = SKAction.wait(forDuration: 0.75)
        let spawnSequence = SKAction.sequence([spawnAction, delayAction])
        
        run(SKAction.repeatForever(spawnSequence))
    }
    
    public func swipeLeft(){
        let moveLeftAction = SKAction.move(to: CGPoint(x: binNode.position.x - movePoints, y: binNode.position.y), duration: 0.2)
        if binNode.position.x - movePoints >= frame.minX {
            binNode.run(moveLeftAction)
        }
    }
    
    public func swipeRight(){
        let moveRightAction = SKAction.move(to: CGPoint(x: binNode.position.x + movePoints, y: binNode.position.y), duration: 0.2)
        if binNode.position.x + movePoints <= frame.maxX {
            binNode.run(moveRightAction)
        }
    }
    
    private func handleCollision(_ contact : SKPhysicsContact){
        // get garbageNode that collides
        if let garbageNode = contact.bodyA.node as? GarbageNode ?? contact.bodyB.node as? GarbageNode {
            garbageNode.removeFromParent()
            gameViewControllerDelegate?.addScore()
        }
    }
    
    
}

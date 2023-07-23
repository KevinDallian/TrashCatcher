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
    let backgroundimage = "gamebackground"
    
    var scoreDelegate : ScoreDelegate?
    
    
    override func didMove(to view: SKView) {
        // gravity and detect collision
        physicsWorld.gravity = CGVector(dx: 0, dy: -5.0)
        physicsWorld.contactDelegate = self
        
        setupBackground(to: view)
        setupBin()
        loopSpawnGarbage()
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2) ||
            (contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1) {
            handleCollision(contact)
        }
    }
    
    //MARK: Setup Background
    private func setupBackground(to view: SKView){
        let tvScreenSize = view.bounds.size
        let sceneAspectRatio = CGSize(width: 16, height: 9)
        
        let widthRatio = tvScreenSize.width / sceneAspectRatio.width
        let heightRatio = tvScreenSize.height / sceneAspectRatio.height
        let scale = min(widthRatio, heightRatio)
        
        let scaledSize = CGSize(width: sceneAspectRatio.width * scale, height: sceneAspectRatio.height * scale)
        self.size = scaledSize
        let background = SKSpriteNode(imageNamed: backgroundimage)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        background.size = scaledSize
        background.alpha = 0.35
        addChild(background)
//
//        // Fade in animation for 3 seconds
//        let fadeInAction = SKAction.fadeAlpha(to: 1, duration: 3.0)
//        // Fade out animation to revert to original opacity
//        let fadeOutAction = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
//        // Sequence both actions
//        let fadeSequence = SKAction.sequence([fadeInAction, fadeOutAction])
//
//        // Run the sequence on the background node
//        background.run(fadeSequence)
        
        // Fade in animation for 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let fadeInAction = SKAction.fadeAlpha(to: 1, duration: 2.0)
            background.run(fadeInAction)
        }
       
    }
    
    //MARK: Setup Bin
    private func setupBin(){
        binNode.position = CGPoint(x: frame.midX, y: frame.minY + 255)
        binNode.physicsBody = SKPhysicsBody(rectangleOf: binNode.size)
        binNode.physicsBody?.isDynamic = false
        
        binNode.physicsBody?.categoryBitMask = 1 // Set a unique bit mask for binNode
        binNode.physicsBody?.collisionBitMask = 0 // No collision with other physics bodies
        binNode.physicsBody?.contactTestBitMask = 2 // Contact will be detected with bit mask 2 (garbageNodea)
        addChild(binNode)
    }
    
    
    //MARK: Garbage Spawning
    private func spawnGarbage(){
        let garbage = GarbageNode()
        let randomXPosition = CGFloat.random(in: frame.minX..<frame.maxX)
        garbage.position = CGPoint(x: randomXPosition, y: frame.maxY)
        
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
    
    func stopLoopSpawnGarbage() {
        self.removeAction(forKey: "spawnsequence")
    }
    
    //MARK: Swipe Handling
    public func swipeLeft(){
        let moveLeftAction = SKAction.move(to: CGPoint(x: binNode.position.x - movePoints, y: binNode.position.y), duration: 0.2)
        if binNode.position.x - movePoints >= frame.minX {
            binNode.run(moveLeftAction)
        }
        let texture = SKTexture(imageNamed: switchCharacterPosition(characterPosition: .right, character: binNode.imageUrl))
        binNode.run(SKAction.setTexture(texture))
        
    }
    
    public func swipeRight(){
        let moveRightAction = SKAction.move(to: CGPoint(x: binNode.position.x + movePoints, y: binNode.position.y), duration: 0.2)
        if binNode.position.x + movePoints <= frame.maxX {
            binNode.run(moveRightAction)
        }
        let texture = SKTexture(imageNamed: switchCharacterPosition(characterPosition: .left, character: binNode.imageUrl))
        binNode.run(SKAction.setTexture(texture))
    }
    
    public func moveBinNode(xPosition : Double){
        let moveAction = SKAction.move(to: CGPoint(x: xPosition, y: binNode.position.y), duration: 0.01)
        binNode.run(moveAction)
    }
    
    //MARK: Collision
    private func handleCollision(_ contact : SKPhysicsContact){
        // get garbageNode that collides
        if let garbageNode = contact.bodyA.node as? GarbageNode ?? contact.bodyB.node as? GarbageNode {
            garbageNode.removeFromParent()
            
            scoreDelegate?.addScore()
        }
    }
    
    //MARK: GarbageNode Remover
    private func removeGarbageNodesBelowScreen() {
        // Get the bottom position of the screen (y = 0 in SpriteKit coordinate system)
        let bottomOfScreen = CGPoint(x: 0, y: 220)
        
        // Loop through all the child nodes in the scene
        for node in children {
            // Check if the node is a GarbageNode and its position is below the screen
            if let garbageNode = node as? GarbageNode, garbageNode.position.y < bottomOfScreen.y {
                // Remove the garbage node from the scene
                garbageNode.removeFromParent()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        removeGarbageNodesBelowScreen()
    }
}

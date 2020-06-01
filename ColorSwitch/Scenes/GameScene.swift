//
//  GameScene.swift
//  ColorSwitch
//
//  Created by Дарья Хомякова on 24/11/19.
//  Copyright © 2019 Дарья Хомякова. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var colorSwitch: Switch!
    var currentColorIndex: Int?
    var scoreLabel: ScoreLabel!
    var score = 0
    var gravity = -2.0
    var playBlingSound: SKAction?
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
        self.playBlingSound = SKAction.playSoundFileNamed("bling", waitForCompletion: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        colorSwitch.turnWheel()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory {
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                detectColorMatch(ball: ball)
            }
        }
    }
    
    func detectColorMatch(ball: SKSpriteNode) {
        if currentColorIndex ==  colorSwitch.state.rawValue {
            if let playBlingSound = self.playBlingSound {
                run(playBlingSound)
            }
            score += 1
            scoreLabel.updateScore(score: score)
            updateWorldGravity()
            ball.run(SKAction.fadeOut(withDuration: 0.25)) {
                ball.removeFromParent()
                self.spawnBall()
            }
        } else {
            gameOver()
        }
    }
    
    func updateWorldGravity() {
        if score >= 0 && score < 10 {
            gravity -= 0.1
            physicsWorld.gravity = CGVector(dx: 0.0, dy: gravity)
        } else if score >= 10 {
            gravity -= 0.5
            physicsWorld.gravity = CGVector(dx: 0.0, dy: gravity)
        }
    }
    
    func setupPhysics()  {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: gravity)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        backgroundColor = LayoutProperties.backgroundColor
        colorSwitch = Switch(frame: frame)
        addChild(colorSwitch.spriteNode)
        scoreLabel = ScoreLabel(frame: frame)
        addChild(scoreLabel.scoreLabelNode)
        spawnBall()
    }
    
    func spawnBall() {
        let randomColor = PlayColors.colors.randomElement()
        currentColorIndex = PlayColors.colors.firstIndex(of: randomColor!)
        let ball = Ball(frame: frame, color: randomColor!)
        addChild(ball.spriteNode)
    }
    
    func gameOver() {
        run(SKAction.playSoundFileNamed("game_over", waitForCompletion: true)) {
           UserDefaults.standard.set(self.score, forKey: "RecentScore")
            if self.score > UserDefaults.standard.integer(forKey: "HighScore") {
                UserDefaults.standard.set(self.score, forKey: "HighScore")
            }
            let menuScene = MenuScene(size: self.view!.bounds.size)
            self.view!.presentScene(menuScene)
        }
    }
}

//
//  GameScene.swift
//  waveStrike
//
//  Created by igmstudent on 2/24/16.
//  Copyright (c) 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let won:Bool
    let score:Int
    
    init(size: CGSize, won: Bool, score: Int) {
        self.won = won
        self.score = score
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        if (won) {
            backgroundColor = UIColor(red: 99, green: 142, blue: 131)
            
            let winLabel = SKLabelNode(fontNamed:"Sailor-Beware")
            winLabel.text = "You Win"
            winLabel.fontSize = 120
            winLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            self.addChild(winLabel)
            
            let finalScoreLabel = SKLabelNode(fontNamed:"Avenir-Medium")
            finalScoreLabel.text = "Score: \(score)"
            finalScoreLabel.fontSize = 50
            finalScoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-150)
            self.addChild(finalScoreLabel)
            
            runAction(SKAction.sequence([
                SKAction.waitForDuration(0.1),
                ]))
        } else {
            backgroundColor = UIColor(red: 54, green: 102, blue: 90)
            
            let loseLabel = SKLabelNode(fontNamed:"Sailor-Beware")
            loseLabel.text = "You Lose"
            loseLabel.fontSize = 100
            loseLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            self.addChild(loseLabel)
            
            let finalScoreLabel = SKLabelNode(fontNamed:"Avenir-Medium")
            finalScoreLabel.text = "Score: \(score)"
            finalScoreLabel.fontSize = 50
            finalScoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-150)
            self.addChild(finalScoreLabel)
            
            runAction(SKAction.sequence([
                SKAction.waitForDuration(0.1),
                ]))
        }
        
        
        let wait = SKAction.waitForDuration(3.0)
        let block = SKAction.runBlock {
            let myScene = MainMenuScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.crossFadeWithDuration(0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.runAction(SKAction.sequence([wait, block]))
    }
}


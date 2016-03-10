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
            backgroundColor = Constants.Scene.WinBackgroundColor
            
            let winLabel = SKLabelNode(fontNamed: Constants.Font.MainFont)
            winLabel.text = "You Win"
            winLabel.fontSize = 120
            winLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            self.addChild(winLabel)
            
            let finalScoreLabel = SKLabelNode(fontNamed: Constants.Font.SecondaryFont)
            finalScoreLabel.text = "Score: \(score)"
            finalScoreLabel.fontSize = 50
            finalScoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-150)
            self.addChild(finalScoreLabel)
            
            runAction(SKAction.sequence([
                SKAction.waitForDuration(0.1),
                ]))
        } else {
            backgroundColor = Constants.Scene.LoseBackgroundColor
            
            let loseLabel = SKLabelNode(fontNamed: Constants.Font.MainFont)
            loseLabel.text = "You Lose"
            loseLabel.fontSize = 100
            loseLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            self.addChild(loseLabel)
            
            let finalScoreLabel = SKLabelNode(fontNamed: Constants.Font.SecondaryFont)
            finalScoreLabel.text = "Score: \(score)"
            finalScoreLabel.fontSize = 50
            finalScoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-150)
            self.addChild(finalScoreLabel)
            
            runAction(SKAction.sequence([
                SKAction.waitForDuration(0.1),
                ]))
        }
        
        
        let wait = SKAction.waitForDuration(1.5)
        let block = SKAction.runBlock {
            let myScene = MainMenuScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.crossFadeWithDuration(0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.runAction(SKAction.sequence([wait, block]))
    }
}


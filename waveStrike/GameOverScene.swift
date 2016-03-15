//
//  GameScene.swift
//  waveStrike
//
//  Created by igmstudent on 2/24/16.
//  Copyright (c) 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene
{
    let won: Bool
    let results: LevelResults
    let tempHealth: CGFloat
    
    init(size: CGSize, won: Bool, results: LevelResults, health: CGFloat)
    {
        self.won = won
        self.results = results
        self.tempHealth = health
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView)
    {
        
        
        let wait = SKAction.waitForDuration(1.5)
        var block = SKAction.runBlock{}
        
        if (won)
        {
            backgroundColor = Constants.Scene.WinBackgroundColor
            
            let winLabel = SKLabelNode(fontNamed: Constants.Font.SecondaryFont)
            winLabel.text = "Level \(self.results.level) Completed"
            winLabel.fontSize = 80
            winLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            self.addChild(winLabel)
            
            let finalScoreLabel = SKLabelNode(fontNamed: Constants.Font.SecondaryFont)
            finalScoreLabel.text = "Score: \(results.score)"
            finalScoreLabel.fontSize = 50
            finalScoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-150)
            self.addChild(finalScoreLabel)
            
            runAction(SKAction.sequence([
                SKAction.waitForDuration(0.1),
                ]))
            
            
            block = SKAction.runBlock
            {
                self.results.level += 1
                let myScene = GameScene(size: self.size, results: self.results, health: self.tempHealth)
                myScene.scaleMode = self.scaleMode
                let reveal = SKTransition.crossFadeWithDuration(0.5)
                self.view?.presentScene(myScene, transition: reveal)
            }
        }
        else
        {
            backgroundColor = Constants.Scene.LoseBackgroundColor
            
            let loseLabel = SKLabelNode(fontNamed: Constants.Font.MainFont)
            loseLabel.text = "You Lose"
            loseLabel.fontSize = 100
            loseLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            self.addChild(loseLabel)
            
            let finalScoreLabel = SKLabelNode(fontNamed: Constants.Font.SecondaryFont)
            finalScoreLabel.text = "Score: \(results.score)"
            finalScoreLabel.fontSize = 50
            finalScoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-150)
            self.addChild(finalScoreLabel)
            
            runAction(SKAction.sequence([
                SKAction.waitForDuration(0.1),
                ]))
        
            block = SKAction.runBlock
            {
                let myScene = MainMenuScene(size: self.size)
                myScene.scaleMode = self.scaleMode
                let reveal = SKTransition.crossFadeWithDuration(0.5)
                self.view?.presentScene(myScene, transition: reveal)
            }
        }
        self.runAction(SKAction.sequence([wait, block]))
    }
}


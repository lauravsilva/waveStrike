//
//  MainMenu.swift
//  waveStrike
//
//  Created by igmstudent on 2/25/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = UIColor(red: 76, green: 104, blue: 119)
        
        let titleLabel = SKLabelNode(fontNamed: Constants.Font.MainFont)
        titleLabel.text = "Wave Strike"
        titleLabel.fontSize = 110
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame)-200)
        self.addChild(titleLabel)
        
        let tapLabel = SKLabelNode(fontNamed: Constants.Font.MainFont)
        tapLabel.fontColor = UIColor(red: 135, green: 171, blue: 162)
        tapLabel.text = "Tap to begin"
        tapLabel.fontSize = 75
        tapLabel.position = CGPoint(x:CGRectGetMidX(self.frame)-50, y:CGRectGetMidY(self.frame)-550)
        self.addChild(tapLabel)
        
        let introLabel1 = SKLabelNode(fontNamed: Constants.Font.SecondaryFont)
        introLabel1.text = "Shoot fast-moving ships, avoid mines,"
        introLabel1.fontSize = 50
        introLabel1.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+250)
        self.addChild(introLabel1)
        
        let introLabel2 = SKLabelNode(fontNamed: Constants.Font.SecondaryFont)
        introLabel2.text = "and watch out for shooting enemies!"
        introLabel2.fontSize = 50
        introLabel2.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+175)
        self.addChild(introLabel2)
        
        
        let mine = SKSpriteNode(imageNamed: Constants.Image.TargetImage3)
        mine.position = CGPoint(x:CGRectGetMidX(self.frame)-350, y:CGRectGetMidY(self.frame)-200)
        self.addChild(mine)
        
        let target1 = SKSpriteNode(imageNamed: Constants.Image.TargetImage1)
        target1.position = CGPoint(x:CGRectGetMidX(self.frame)-200, y:CGRectGetMidY(self.frame)-200)
        self.addChild(target1)
        
        let player = SKSpriteNode(imageNamed: Constants.Image.PlayerImage)
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-200)
        self.addChild(player)
        
        let target2 = SKSpriteNode(imageNamed: Constants.Image.TargetImage2)
        target2.position = CGPoint(x:CGRectGetMidX(self.frame)+200, y:CGRectGetMidY(self.frame)-200)
        self.addChild(target2)
        
        let target3 = SKSpriteNode(imageNamed: Constants.Image.TargetImage3)
        target3.position = CGPoint(x:CGRectGetMidX(self.frame)+400, y:CGRectGetMidY(self.frame)-200)
        self.addChild(target3)
        
    }
    
    func sceneTapped() {
        let myScene = GameScene(size:self.size, results: LevelResults(level: 1, score: 0), health: 100)
        myScene.scaleMode = scaleMode
        let reveal = SKTransition.crossFadeWithDuration(1.5)
        self.view?.presentScene(myScene, transition: reveal)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        sceneTapped()
    }
}
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
        titleLabel.fontSize = 100
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame)-150)
        self.addChild(titleLabel)
        
        let tapLabel = SKLabelNode(fontNamed: Constants.Font.MainFont)
        tapLabel.text = "Tap to begin"
        tapLabel.color = UIColor(red: 82, green: 121, blue: 111)
        tapLabel.fontSize = 60
        tapLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(tapLabel)
    }
    
    func sceneTapped() {
        let myScene = GameScene(size:self.size)
        myScene.scaleMode = scaleMode
        let reveal = SKTransition.crossFadeWithDuration(1.5)
        self.view?.presentScene(myScene, transition: reveal)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        sceneTapped()
    }
}
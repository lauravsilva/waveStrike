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

        backgroundColor = UIColor(red: 202, green: 210, blue: 197)
        let myLabel = SKLabelNode(fontNamed:"Sailor-Beware")
        myLabel.text = "Tap to begin"
        myLabel.color = UIColor(red: 82, green: 121, blue: 111)
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
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
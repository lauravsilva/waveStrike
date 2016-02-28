//
//  GameScene.swift
//  waveStrike
//
//  Created by igmstudent on 2/24/16.
//  Copyright (c) 2016 igmstudent. All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
    let player = Player();  //Player sprite
    
    override func didMoveToView(view: SKView)
    {
        //Background color
        backgroundColor = UIColor(red: 76, green: 104, blue: 119)
        
        //Test label
        let myLabel = SKLabelNode(fontNamed:"Sailor-Beware")
        myLabel.text = "Wave Strike"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(myLabel);
        
        //Player
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5);
        addChild(player);
        
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
    }
    
}



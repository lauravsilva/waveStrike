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
    var player = Player()                   //Player sprite
    var lastUpdateTime: NSTimeInterval = 0  //Time of last updatev
    var dt: CGFloat = 0                     //Delta Time
    var lastTouchLocation: CGPoint?
    
    override init(size: CGSize)
    {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView)
    {
        //Background color
        backgroundColor = UIColor(red: 76, green: 104, blue: 119)
        
        //Test label
        let myLabel = SKLabelNode(fontNamed:"Sailor-Beware")
        myLabel.text = "Wave Strike"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(myLabel)
        
        //Player
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(player);
    }
    
    //Update
    override func update(currentTime: CFTimeInterval)
    {
        //Set delta time
        if(lastUpdateTime > 0)
        {
            dt = CGFloat(currentTime - lastUpdateTime)
        }
        else
        {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        //Set player to accelerate towards previously tapped position
        if let lastTouchLocation = lastTouchLocation
        {
            player.acc = (lastTouchLocation - player.position).normalized() * 5;
        }
        
        //Update player
        player.update(dt)
    }
    
    //Perform upon touch
    func sceneTouched(touchLocation:CGPoint)
    {
        lastTouchLocation = touchLocation
        print("MEEP!");
    }
    
    //Touch began event
    override func touchesBegan(
        touches: Set<UITouch>,
        withEvent event: UIEvent?)
    {
        guard let touch = touches.first
            else
        {
            return
        }
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
    }
    
    //Touch moved event
    override func touchesMoved(
        touches: Set<UITouch>,
        withEvent event: UIEvent?)
    {
        guard let touch = touches.first
            else
        {
            return
        }
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
    }
}



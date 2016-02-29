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
    let ctx = UIGraphicsGetCurrentContext()
    
    var boundary: CGRect?
    var rectFiring = SKShapeNode()          //Rect for firing rate indicator
    var circleLarge = SKShapeNode()         //Large circle for wheel
    var circleSmall = SKShapeNode()         //Small circle for wheel
    var player = Player()                   //Player sprite
    var lastUpdateTime: NSTimeInterval = 0  //Time of last updatev
    var dt: CGFloat = 0                     //Delta Time
    var fireTouchLocation: CGPoint?         //Location tapped for firing
    var dragTouchLocation: CGPoint?         //Location tapped for dragging
    
    //Init
    override init(size: CGSize)
    {
        super.init(size: size)
    }

    //Why does this ever need to exist?
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Upon scene being loaded
    override func didMoveToView(view: SKView)
    {
        //Background color
        backgroundColor = UIColor(red: 76, green: 104, blue: 119)
        
        //Test label
        let myLabel = SKLabelNode(fontNamed:"Sailor-Beware")
        myLabel.text = "Wave Strike"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame)-100)
        self.addChild(myLabel)
        
        //Boundary
        boundary = CGRect(
            origin: CGPoint(x: (self.size.width - self.size.height * self.size.height / self.size.width) / 2, y: 0),
            size: CGSize(width: self.size.height * self.size.height / self.size.width, height: self.size.height))
        
        //Player
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(player);
        
        //Circles!
        circleLarge = SKShapeNode(circleOfRadius: 180.0)
        circleLarge.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 500)
        circleLarge.fillColor = SKColor.init(red: 255, green: 255, blue: 255, alpha: 0.25)
        circleLarge.strokeColor = SKColor.clearColor()
        addChild(circleLarge)
        circleSmall = SKShapeNode(circleOfRadius: 45.0)
        circleSmall.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 500)
        circleSmall.fillColor = SKColor.init(red: 192, green: 200, blue: 255, alpha: 0.25)
        circleSmall.strokeColor = SKColor.clearColor()
        addChild(circleSmall)
        
        //Rects!
        rectFiring = SKShapeNode(
            rect: CGRect(
                origin: CGPoint(x: 0, y: 0),
                size: CGSize(
                    width: 800.0,
                    height: 50.0)))
        rectFiring.name = "rectFiring"
        rectFiring.position = CGPoint(x : CGRectGetMidX(self.frame), y : self.frame.height - 160)
        rectFiring.fillColor = SKColor.init(red: 255, green: 255, blue: 255, alpha: 0.25)
        rectFiring.strokeColor = SKColor.clearColor()
        addChild(rectFiring)
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
        if let dragTouchLocation = dragTouchLocation
        {
            player.acc = dragTouchLocation * 180 / dragTouchLocation.length()
        }
        
        //Update player
        player.update(dt)
        player.wrap(boundary!)
        
        //Update Rect
        rectFiring.xScale = player.fireRateCounter / player.fireRate
        rectFiring.position.x = CGRectGetMidX(self.frame) - 400 * player.fireRateCounter / player.fireRate
    }
    
    //Fire bullet
    func fireBullets()
    {
        //Return if player is not ready
        if(player.getGunsReady())
        {
            return
        }
        
        let guns = player.getGuns() //Position for guns
        
        for(var i = 0; i < 4; i++)
        {
            // Set up initial location of projectile
            let projectile = SKSpriteNode(imageNamed: "projectile")
            projectile.position = guns[i]
            
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.dynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
            projectile.physicsBody?.usesPreciseCollisionDetection = true
            
            addChild(projectile)
            
            // Get the direction of where to shoot
            let direction = i < 2 ?
                CGPoint(x: cos(player.zRotation), y: sin(player.zRotation)) :
                CGPoint(x: cos(player.zRotation), y: sin(player.zRotation)) * -1    //Last 2 guns face the other way.
            
            // Make it shoot far enough to be guaranteed off screen
            let shootAmount = direction * 2000
            
            // Add the shoot amount to the current position
            let realDest = shootAmount + projectile.position
            
            // Create the actions
            let actionMove = SKAction.moveTo(realDest, duration: 2.0)
            let actionMoveDone = SKAction.removeFromParent()
            projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        }
    }
    
    //Perform upon touch
    func sceneTouched(touchLocation:CGPoint)
    {
        if((touchLocation - circleLarge.position).length() < 200)
        {
            dragTouchLocation = touchLocation - circleLarge.position
        }
        else
        {
            fireTouchLocation = touchLocation
        }
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
    
    
    // Touch end event (fire bullets)
    override func touchesEnded(
        touches: Set<UITouch>,
        withEvent event: UIEvent?)
    {
        // Choose one of the touches to work with
        guard let touch = touches.first else
        {
            return
        }
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
        
        if((touchLocation - circleLarge.position).length() > 200)
        {
            fireBullets()
        }
    }
    
}



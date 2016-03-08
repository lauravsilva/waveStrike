//
//  GameScene.swift
//  waveStrike
//
//  Created by igmstudent on 2/24/16.
//  Copyright (c) 2016 igmstudent. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate
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
    var targets: [Target] = []              //Array of targets
    var numOfInitTargets:Int                //Number of initial number of targets
    var gameOver = false
    
    //Init
    override init(size: CGSize)
    {
        numOfInitTargets = Int(arc4random_uniform(5) + 5)
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
        backgroundColor = UIColor(red: 128, green: 158, blue: 169)
        
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
        player.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 62, height: 179))
        player.physicsBody?.dynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Target
        player.physicsBody?.collisionBitMask = PhysicsCategory.None
        player.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(player)
        
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
        
        // Targets
        for(var i = 0; i < numOfInitTargets; i++)
        {
            let target = Target(boundary: boundary!)
            target.name = "target"
            addChild(target)
            targets.append(target)
        }
        
        //Physics!
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
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
        
        //player.vel = CGPoint(x: 0, y: 50);
        //Set player to accelerate towards previously tapped position
        if let dragTouchLocation = dragTouchLocation
        {
            player.acc = dragTouchLocation * player.maxSpeed / 200 - player.vel
            
            //Limit player acceleration
            if(player.acc.length() > player.maxAcc)
            {
                player.acc = player.acc.normalized() * player.maxAcc
            }
        }
        
        //Update player
        player.update(dt)
        player.wrap(boundary!)
        
        //Update targets
        for target in targets
        {
            target.update(dt)
            target.wrap(boundary!)
        }

        
        //Update Rect
        rectFiring.xScale = player.fireRateCounter / player.fireRate
        rectFiring.position.x = CGRectGetMidX(self.frame) - 400 * player.fireRateCounter / player.fireRate

        
        //Win screen when there are no active targets remaining
        if targets.count <= 0 {
            let gameOverScene = GameOverScene(size: size, won: true)
            gameOverScene.scaleMode = scaleMode
            let reveal = SKTransition.crossFadeWithDuration(0.5)
            view?.presentScene(gameOverScene, transition: reveal)
        }
        
        //Game Over screen when there are is a collision between target and player
        if gameOver == true {
            gameOver = false
            let gameOverScene = GameOverScene(size: size, won: false)
            gameOverScene.scaleMode = scaleMode
            let reveal = SKTransition.crossFadeWithDuration(0.5)
            view?.presentScene(gameOverScene, transition: reveal)
        }
        
    }
    
    //Fire bullet
    func fireBullets(sideToFire: Bool)
    {
        //Return if player is not ready
        if(player.getGunsReady())
        {
            return
        }
        
        let guns = player.getGuns() //Position for guns
        var direction: CGPoint
        
        for(var i = 0; i < 4; i++)
        {
            // Set up initial location of projectile
            let projectile = SKSpriteNode(imageNamed: "ship_gun_base")
            projectile.position = guns[i]
            
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.dynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Target
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
            projectile.physicsBody?.usesPreciseCollisionDetection = true
            
            addChild(projectile)
            
            // Get the direction of where to shoot
//            let direction = sideToFire == false ?
//                CGPoint(x: cos(player.zRotation), y: sin(player.zRotation)) :
//                CGPoint(x: cos(player.zRotation), y: sin(player.zRotation)) * -1
            
            if (sideToFire){ //left
                direction = CGPoint(x: cos(player.zRotation), y: sin(player.zRotation)) * -1
            }
            else { //right
                direction = CGPoint(x: cos(player.zRotation), y: sin(player.zRotation))
            }
            
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
    
    //On contact
    func didBeginContact(contact: SKPhysicsContact)
    {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        if (firstBody == secondBody){
            return
        }
        
        guard firstBody.node != nil else{
            return
        }
        
        guard secondBody.node != nil else{
            return
        }
        
        // Target + player
        if (
            (firstBody.categoryBitMask & PhysicsCategory.Target != 0) &&
                (secondBody.categoryBitMask & PhysicsCategory.Player != 0))
        {
            gameOver = true
            return
        }
        
        
        // Target + projectile
        if (
            (firstBody.categoryBitMask & PhysicsCategory.Target != 0) &&
                (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0))
        {
            projectileDidCollideWithTarget(firstBody.node as! SKSpriteNode, target: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    //On collision
    func projectileDidCollideWithTarget(projectile:SKSpriteNode, target:SKSpriteNode)
    {
        projectile.removeFromParent()
        target.removeFromParent()
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
        var touchLeft:Bool      //if true, touch is on left, if false, touch is on right
        
        // Choose one of the touches to work with
        guard let touch = touches.first else
        {
            return
        }
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
        
        //Fire bullets if releasing a touch beyond the circle
        if((touchLocation - circleLarge.position).length() > 200)
        {
            //WHY ARE ANGLE SO COMPLICATED?!
            var offset = (π / 2 - player.zRotation) % (2 * π)               //PLAYER ROTATION WRAPPED TO MATCH CGPOINT ANGLE METHOD
            if(offset < 0)
            {
                offset += 2 * π                                             //NO, YOU WILL NOT BE NEGATIVE
            }
            offset = π - (touchLocation - player.position).angle - offset   //SUBTRACT PLAYER ROTATION FROM TOUCH ANGLE TO GET A RELATIVE ANGLE
            
            // This side
            if (
                (offset > -π && offset < 0) ||    //RELATIVE ANGLE CONDITION 1
                (offset > π && offset < 2 * π))   //RELATIVE ANGLE CONDITION 2
            {
                touchLeft = true
            }
            // The other side
            else
            {
                touchLeft = false
            }
            
            fireBullets(touchLeft)
        }
    }
    
}



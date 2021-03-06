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
    
    //Constants
    let ctx = UIGraphicsGetCurrentContext()
    let results: LevelResults
    let scoreLabel = SKLabelNode(fontNamed: Constants.Font.SecondaryFont)
    let tempHealth: CGFloat
    let emitter = SKEmitterNode(fileNamed: "smoke")!
    let cannonSound: SKAction = SKAction.playSoundFileNamed(
        Constants.Sound.Cannon, waitForCompletion: false)
    
    //Variables
    var boundary: CGRect?
    var rectFiring = SKShapeNode()          //Rect for firing rate indicator
    var rectHealth = SKShapeNode()          //Health bar
    var circleLarge = SKShapeNode()         //Large circle for wheel
    var circleSmall = SKShapeNode()         //Small circle for wheel
    var circleIndic = SKShapeNode()         //Small circle for wheel
    var dragRadius:CGFloat = 180;           //Max radius for directional dragging
    
    var lastUpdateTime: NSTimeInterval = 0  //Time of last updatev
    var dt: CGFloat = 0                     //Delta Time
    var fireTouchLocation: CGPoint?         //Location tapped for firing
    var dragTouchLocation: CGPoint?         //Location tapped for dragging
    
    var player = Player()                   //Player sprite
    var water: SKSpriteNode                 //Water sprite
    let waterAnimation: SKAction            //Water animation
    
    var enemies: [Enemy] = []               //Array of targets
    var shootingEnemy: [Shooter] = []       //Array of shooting enemies
    var shooterTargetHealth = 8             //Health points for shooterTarget
    var numOfInitMovingTargets = 0          //Number of initial number of targets
    var numOfActiveTargets = 0              //Number of active targets
    var numshot = 0;
    
    
    //MARK: Init
    init(size: CGSize, results: LevelResults, health: CGFloat)
    {
        self.results = results
        self.tempHealth = health
        
        // load water ripple images onto waterAnimation for player
        self.water = SKSpriteNode(imageNamed: Constants.Image.WaterRipple)
        var waterTextures:[SKTexture] = []
        for i in 0...4 {
            waterTextures.append(SKTexture(imageNamed: "water_ripple_medium_00\(i)"))
        }
        waterAnimation = SKAction.animateWithTextures(waterTextures,
            timePerFrame: 0.1)
        
        
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
        backgroundColor = Constants.Scene.GameBackgroundColor
        
        //Title label
        let titleLabel = SKLabelNode(fontNamed: Constants.Font.MainFont)
        titleLabel.text = "Wave Strike"
        titleLabel.fontSize = 45
        titleLabel.verticalAlignmentMode = .Top
        titleLabel.horizontalAlignmentMode = .Left
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.frame)-500, y:CGRectGetMaxY(self.frame)-30)
        self.addChild(titleLabel)
        
        //Score label
        scoreLabel.text = "Level: \(self.results.level)  Score: \(self.results.score)"
        scoreLabel.fontSize = 45
        scoreLabel.verticalAlignmentMode = .Top
        scoreLabel.horizontalAlignmentMode = .Right
        scoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame)+500, y:CGRectGetMaxY(self.frame)-30)
        self.addChild(scoreLabel)
        
        //Boundary
        boundary = CGRect(
            origin: CGPoint(x: (self.size.width - self.size.height * self.size.height / self.size.width) / 2, y: 0),
            size: CGSize(width: self.size.height * self.size.height / self.size.width, height: self.size.height))
        
        //Player
        player.health = tempHealth
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        player.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 60, height: 170))
        player.physicsBody?.dynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Target
        player.physicsBody?.collisionBitMask = PhysicsCategory.None
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.zPosition = 2
        
        self.addChild(player)
        
        // Water
        water.position = player.position
        self.addChild(water)
        
        //Circles!
        circleLarge = SKShapeNode(circleOfRadius: dragRadius)
        circleLarge.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 500)
        circleLarge.fillColor = SKColor.init(red: 1, green: 1, blue: 1, alpha: 0.25)
        circleLarge.strokeColor = SKColor.clearColor()
        addChild(circleLarge)
        
        circleSmall = SKShapeNode(circleOfRadius: 45.0)
        circleSmall.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 500)
        circleSmall.fillColor = SKColor.init(red: 0.75, green: 0.8, blue: 1.0, alpha: 0.25)
        circleSmall.strokeColor = SKColor.clearColor()
        addChild(circleSmall)
        
        circleIndic = SKShapeNode(circleOfRadius: 55.0)
        circleIndic.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 500)
        circleIndic.fillColor = SKColor.init(red: 0.75, green: 0.8, blue: 1.0, alpha: 0.25)
        circleIndic.strokeColor = SKColor.clearColor()
        addChild(circleIndic)
        
        //Rects!
        rectFiring = SKShapeNode(
            rect: CGRect(
                origin: CGPoint(x: 0, y: 0),
                size: CGSize(
                    width: 800.0,
                    height: 50.0)))
        rectFiring.name = "rectFiring"
        rectFiring.position = CGPoint(x : CGRectGetMidX(self.frame), y : self.frame.height - 210)
        rectFiring.fillColor = SKColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.25)
        rectFiring.strokeColor = SKColor.clearColor()
        addChild(rectFiring)
        
        rectHealth = SKShapeNode(
            rect: CGRect(
                origin: CGPoint(x: 0, y: 0),
                size: CGSize(
                    width: 800.0,
                    height: 50.0)))
        rectHealth.name = "rectHealth"
        rectHealth.position = CGPoint(x : CGRectGetMidX(self.frame), y : self.frame.height - 150)
        rectHealth.fillColor = SKColor.init(red: 1.0, green: 0.1, blue: 0.1, alpha: 0.33)
        rectHealth.strokeColor = SKColor.clearColor()
        addChild(rectHealth)
        
        //Tutorial
        if(results.level == 1)
        {
            let dirMove = SKLabelNode(fontNamed: Constants.Font.SecondaryFont)
            dirMove.text = "Tap the wheel below to control the ship,"
            dirMove.fontColor = UIColor(red: 106, green: 109, blue: 108, alpha: 0.7)
            dirMove.fontSize = 45
            dirMove.verticalAlignmentMode = .Center
            dirMove.horizontalAlignmentMode = .Center
            dirMove.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+450)
            dirMove.zPosition = 0
            self.addChild(dirMove)
            
            let dirShoot = SKLabelNode(fontNamed: Constants.Font.SecondaryFont)
            dirShoot.text = "and tap the water to shoot"
            dirShoot.fontColor = UIColor(red: 106, green: 109, blue: 108, alpha: 0.7)
            dirShoot.fontSize = 45
            dirShoot.verticalAlignmentMode = .Center
            dirShoot.horizontalAlignmentMode = .Center
            dirShoot.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+380)
            dirShoot.zPosition = 0
            self.addChild(dirShoot)
            
            // Targets
            numOfInitMovingTargets = 4
            for(var i = 0; i < numOfInitMovingTargets; i++)
            {
                let enemy = Patroller(
                    position: Constants.TutorialStart.positions[i],
                    velocityDir: Constants.TutorialStart.velocityDirs[i]
                )
                enemy.position += player.position  //Position targets relative to the player
                enemy.name = "target"
                addChild(enemy)
                enemies.append(enemy)
            }
            
        }
            
        // Not tutorial
        else
        {
            // Targets
            numOfInitMovingTargets = (results.level - 1) * 2
            for(var i = 0; i < numOfInitMovingTargets; i++)
            {
                let targetRotation = CGFloat.random(min: 0, max: 2 * π)
                let enemy = Patroller(
                    position: CGPoint(
                        x: CGFloat.random(min: boundary!.minX, max: boundary!.maxX),
                        y: CGFloat.random(min: boundary!.minY, max: boundary!.maxY/2)),
                    velocityDir : CGPoint(
                        x: -sin(targetRotation),
                        y: cos(targetRotation))
                )
                enemy.name = "target"
                addChild(enemy)
                enemies.append(enemy)
            }
        
            // Mines
            let numOfMines = results.level * 4
            for(var j = 0; j < numOfMines; j++)
            {
                let mine = Mine(
                    position: CGPoint(
                        x: CGFloat.random(min: boundary!.minX, max: boundary!.maxX),
                        y: CGFloat.random(min: boundary!.minY, max: boundary!.maxY))
                )
                mine.name = "mineTarget"
                addChild(mine)
            }
            
            
            // Shooter
            var numOfShooters = results.level - 2
            if numOfShooters > 3 {
                numOfShooters = 2
            }
            
            let targetRotationShooter = CGFloat.random(min: 0, max: 2 * π)
            for(var k = 0; k < numOfShooters; k++){
                let shooterEnemy = Shooter(
                    position: CGPoint(
                        x: CGFloat.random(min: boundary!.minX, max: boundary!.maxX),
                        y: CGFloat.random(min: boundary!.minY, max: boundary!.maxY/2)),
                    velocityDir : CGPoint(
                        x: -sin(targetRotationShooter),
                        y: cos(targetRotationShooter))
                )
                shooterEnemy.name = "shootingTarget"
                addChild(shooterEnemy)
                shootingEnemy.append(shooterEnemy)
            }
            
            numOfInitMovingTargets += numOfShooters
        }
        
        //Active targets counter
        numOfActiveTargets = numOfInitMovingTargets * 2
        
        //Emitter
        emitter.zPosition = 3
        emitter.particleBirthRate = 0
        addChild(emitter)
        
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
            startWaterAnimation()
        }
        else
        {
            dt = 0
            stopWaterAnimation()
        }
        lastUpdateTime = currentTime
        
        //player.vel = CGPoint(x: 0, y: 50);
        //Set player to accelerate towards previously tapped position
        if let dragTouchLocation = dragTouchLocation
        {
            player.acc = dragTouchLocation * player.maxSpeed / dragRadius - player.vel
            
            //Limit player acceleration
            if(player.acc.length() > player.maxAcc)
            {
                player.acc = player.acc.normalized() * player.maxAcc
            }
        }
        
        //Update player
        player.update(dt)
        player.wrap(boundary!)
        
        //Update water to follow player
        water.position = player.position
        water.zRotation = player.zRotation
        
        //Update targets
        for enemy in enemies
        {
            enemy.update(dt)
            enemy.wrap(boundary!)
        }
        
        
        for shooter in shootingEnemy{
            shooter.update(dt)
            shooter.wrap(boundary!)
        }
   
        
        //Update Rect
        rectFiring.xScale = player.fireRateCounter / player.fireRate
        rectFiring.position.x = CGRectGetMidX(self.frame) - 400 * player.fireRateCounter / player.fireRate
        rectHealth.xScale = player.health / player.maxHealth
        rectHealth.position.x = CGRectGetMidX(self.frame) - 400 * player.health / player.maxHealth
        
        //Emitter
        if player.health < 50 {
            emitter.particleBirthRate = 30
            emitter.position = CGPoint(x: player.position.x, y: player.position.y)
            emitter.particleRotation = player.zRotation
        }
        
        //Win screen when there are no active targets remaining
        if numOfActiveTargets <= 1 {
            let gameOverScene = GameOverScene(size: size, won: true, results: results, health: player.health)
            gameOverScene.scaleMode = scaleMode
            let reveal = SKTransition.crossFadeWithDuration(0.5)
            view?.presentScene(gameOverScene, transition: reveal)
        }
        
        //Game Over screen when player health < 0
        if player.health <= 0 {
            let gameOverScene = GameOverScene(size: size, won: false, results: results, health: player.health)
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
        
        runAction(cannonSound)
        
        for(var i = 0; i < 4; i++)
        {
            // Set up initial location of projectile
            let projectile = SKSpriteNode(imageNamed: Constants.Image.ProjectileImage)
            projectile.position = guns[i]
            
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.dynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Target
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
            projectile.physicsBody?.usesPreciseCollisionDetection = true
            
            addChild(projectile)
            
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
    
    //MARK: Collisions
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
            playerDidCollideWithTarget(firstBody.node as! SKSpriteNode)
        }
        
        
        // Target + projectile
        if (
            (firstBody.categoryBitMask & PhysicsCategory.Target != 0) &&
                (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0))
        {
            projectileDidCollideWithTarget(firstBody.node as! SKSpriteNode, projectile: secondBody.node as! SKSpriteNode)
        }
        
        // Projectile + player
        if (
            (firstBody.categoryBitMask & PhysicsCategory.Projectile != 0) &&
                (secondBody.categoryBitMask & PhysicsCategory.Player != 0))
        {
            projectileDidCollideWithTarget(firstBody.node as! SKSpriteNode)
        }
        
    }
    
    //On collision: player and projectile
    func projectileDidCollideWithTarget(projectile:SKSpriteNode)
    {
        self.scoreLabel.text = "Level: \(self.results.level)  Score: \(self.results.score)"
        player.health -= 25
        spriteBlink(player, blinkCount: 2)
    }
    
    //On collision: target and projectile
    func projectileDidCollideWithTarget(target:SKSpriteNode, projectile:SKSpriteNode)
    {
        // shoot mine, ++ score
        if(target.name == "mineTarget"){
            self.results.score += 1
        }
            
        // shoot shooting target, it takes damage
        else if(target.name == "shootingTarget"){
            shooterTargetHealth--
            spriteBlink(target, blinkCount: 3)
            
            if (shooterTargetHealth <= 0){
                self.results.score += 6
                target.removeFromParent()
            }
            
            self.scoreLabel.text = "Level: \(self.results.level)  Score: \(self.results.score)"
            projectile.removeFromParent()
            return
        }
            
        // shoot target, ++ score and decrease active target count
        else{
            self.numOfActiveTargets--
            self.results.score += 4
            numshot++
        }
        
        self.scoreLabel.text = "Level: \(self.results.level)  Score: \(self.results.score)"
        projectile.removeFromParent()
        target.removeFromParent()
    }
    
    //On collision: target + player
    func playerDidCollideWithTarget(target:SKSpriteNode)
    {
        // hit mine, decrease health
        if (target.name == "mineTarget"){
            player.health -= 25
            spriteBlink(player, blinkCount: 2)
            target.removeFromParent()
        }
            
        // hit shooting target, double decrease health
        else if(target.name == "shootingTarget"){
            player.health -= 50
            spriteBlink(player, blinkCount: 2)
        }
            
        // hit by target, decrease health and active target count
        else{
            self.scoreLabel.text = "Level: \(self.results.level)  Score: \(self.results.score)"
            player.health -= 25
            spriteBlink(player, blinkCount: 2)
            self.numOfActiveTargets--
            numshot++
            target.removeFromParent()
        }
    }
    
    // Sprite node blinks blinks
    func spriteBlink(sprite: SKSpriteNode, blinkCount: Int) {
        let blink:SKAction = SKAction.sequence([
            SKAction.fadeOutWithDuration(0.10),
            SKAction.fadeInWithDuration(0.15)
            ])
        sprite.runAction(SKAction.repeatAction(blink, count: blinkCount))
    }
    
    //MARK: Touches
    //Perform upon touch
    func sceneTouched(touchLocation:CGPoint)
    {
        if((touchLocation - circleLarge.position).length() < dragRadius)
        {
            dragTouchLocation = touchLocation - circleLarge.position
            circleIndic.position = touchLocation
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
            offset = -(touchLocation - player.position).angle - offset   //SUBTRACT PLAYER ROTATION FROM TOUCH ANGLE TO GET A RELATIVE ANGLE
            
            // This side
            if (
                (offset > -2 * π && offset < -π) ||    //RELATIVE ANGLE CONDITION 1
                (offset > 0 && offset < π))            //RELATIVE ANGLE CONDITION 2
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
 
    //MARK: Animation
    // Start ripple water animation
    func startWaterAnimation() {
        if water.actionForKey("animation") == nil {
            water.runAction(
                SKAction.repeatActionForever(waterAnimation),
                withKey: "animation")
        }
    }
    
    // Stop ripple water animation
    func stopWaterAnimation() {
        water.removeActionForKey("animation")
    }
    
}



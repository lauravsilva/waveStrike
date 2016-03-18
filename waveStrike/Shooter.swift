import SpriteKit

//Shooting enemy. Moves and shoots.
class Shooter : Enemy
{
    init(position: CGPoint, velocityDir: CGPoint)
    {
        super.init(
            position: position,
            velocity: velocityDir * 50,
            maxSpeed: 50,
            rotSpeed: π / 3,
            texture: SKTexture(imageNamed: Constants.Image.TargetImage2))
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Get an array of the positions of the guns.
    func getGuns() -> [CGPoint]
    {
        let points: [CGPoint] =
        [
            CGPoint(x: self.position.x, y: self.position.y) +
                CGPoint(x: -50 * sin(self.zRotation), y: 50 * cos(self.zRotation)),
            
            CGPoint(x: self.position.x, y: self.position.y) +
                CGPoint(x: 50 * sin(self.zRotation), y: -50 * cos(self.zRotation)),
            
            CGPoint(x: self.position.x, y: self.position.y) +
                CGPoint(x: -50 * sin(self.zRotation), y: 50 * cos(self.zRotation)),
            
            CGPoint(x: self.position.x, y: self.position.y) +
                CGPoint(x: 50 * sin(self.zRotation), y: -50 * cos(self.zRotation)),
        ]
        return points
    }
    
    
    //Fire bullet
    func fireBullets()
    {
        let side = randomBool()
        let guns = self.getGuns() //Position for guns
        var direction: CGPoint
        
        for(var i = 0; i < 4; i++)
        {
            // Set up initial location of projectile
            let projectile = SKSpriteNode(imageNamed: Constants.Image.ProjectileImage)
            projectile.position = guns[i]
            
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.dynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Player
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
            projectile.physicsBody?.usesPreciseCollisionDetection = true
            
            addChild(projectile)
            
            if (side){
                direction = CGPoint(x: cos(self.zRotation), y: sin(self.zRotation)) * -1
            }
            else {
                direction = CGPoint(x: cos(self.zRotation), y: sin(self.zRotation))
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

}
import SpriteKit

class Target : Ship
{
    init(boundary: CGRect, position: CGPoint, velocityDir: CGPoint)
    {
        let texture = SKTexture(imageNamed: Constants.Image.TargetImage1)
        super.init(
            texture: texture,
            position: position,
            maxSpeed: 80,
            rotSpeed: π / 3)
        self.vel = velocityDir
        self.vel *= self.maxSpeed
        self.zRotation = self.vel.angle
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size) // 1
        self.physicsBody?.dynamic = true // 2
        self.physicsBody?.categoryBitMask = PhysicsCategory.Target // 3
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // 4
        self.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(dt: CGFloat)
    {
        super.update(dt)
    }
}
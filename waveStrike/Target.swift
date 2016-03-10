import SpriteKit

class Target : Ship
{
    init(boundary: CGRect, position: CGPoint)
    {
        let texture = SKTexture(imageNamed: "ship_small_body")
        super.init(
            texture: texture,
            position: position,
            /*
            position: CGPoint(
                x: CGFloat.random(
                    min: boundary.minX,
                    max: boundary.maxX),
                y: CGFloat.random(
                    min: boundary.minY,
                    max: boundary.maxY)),*/
            maxSpeed: 80,
            rotSpeed: π / 3)
        self.zRotation = CGFloat.random(min: 0, max: 2 * π)
        self.vel = CGPoint(x: -sin(self.zRotation) * self.maxSpeed, y: cos(self.zRotation) * self.maxSpeed)
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
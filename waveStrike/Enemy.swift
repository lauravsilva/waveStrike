import SpriteKit

class Enemy : Ship
{
    init(
        position: CGPoint,  //Position of the enemy
        velocity: CGPoint,  //Starting velocity of the enemy
        maxSpeed: CGFloat,  //Maximum scalar speed of the enemy
        rotSpeed: CGFloat,  //Rotational speed of the enemy
        texture: SKTexture) //Texture of the enemy
    {
        super.init(
            texture: texture,
            position: position,
            maxSpeed: maxSpeed,
            rotSpeed: rotSpeed)
        
        //Set velocity and facing direction
        self.vel = velocity
        self.zRotation = self.vel.angle - π / 2
        
        //Physics stuff
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
}
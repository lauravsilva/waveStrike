import SpriteKit

class Ship : SKSpriteNode
{
    var vel: CGPoint        //Ship velocity
    var acc: CGPoint        //Ship acceleration
    var maxSpeed: CGFloat   //Maximum speed of ship
    var rotSpeed: CGFloat   //Rotational speed of ship
    
    //Init
    init(
        texture: SKTexture!,
        position: CGPoint,
        maxSpeed: CGFloat,
        rotSpeed: CGFloat)
    {
        self.vel = CGPoint(x: 0, y: 0)
        self.acc = CGPoint(x: 0, y: 0)
        self.maxSpeed = maxSpeed
        self.rotSpeed = rotSpeed
        super.init(texture: texture, color: UIColor(), size: texture.size())
        self.position = position
    }
    
    //This thing
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Update ship
    func update(dt: CGFloat)
    {
        print(self.acc)
        self.vel += self.acc * dt;
        if(self.vel.length() > maxSpeed)
        {
            self.vel = self.vel.normalized() * maxSpeed
        }
        self.position += self.vel * dt;
        self.rotate(dt);
    }
    
    //Rotate ship to face it's direction of movement
    func rotate(dt: CGFloat)
    {
        if(self.vel.length() == 0)
        {
            return
        }
            
        let shortest = shortestAngleBetween(self.vel.angle, angle2: self.zRotation + π / 2)
        let amtToRotate = self.rotSpeed * dt
        if(abs(shortest) < amtToRotate)
        {
            self.zRotation -= shortest;
        }
        else
        {
            self.zRotation -= amtToRotate * CGFloat(sign(Float(shortest)))
        }
    }
    
    //Wrap position to be within screen space
    func wrap(rect: CGRect)
    {
        if(self.position.x < rect.minX)
        {
            self.position.x += rect.width
        }
        if(self.position.x > rect.maxX)
        {
            self.position.x -= rect.width
        }
        if(self.position.y < rect.minY)
        {
            self.position.y += rect.height
        }
        if(self.position.y > rect.maxY)
        {
            self.position.y -= rect.height
        }
    }
}
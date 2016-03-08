import SpriteKit

class Player : Ship
{
    var maxAcc: CGFloat  //Scalar acceleration value
    var fireRate: CGFloat
    var fireRateCounter: CGFloat
    var maxHealth: CGFloat
    var health: CGFloat
    
    init()
    {
        maxAcc = 120.0
        fireRate = 1.5
        fireRateCounter = 0.0
        maxHealth = 100.0
        health = 100.0
        let texture = SKTexture(imageNamed: "ship_medium_body")
        super.init(
            texture: texture,
            position: CGPoint(x: 0, y: 0),
            maxSpeed: 240,
            rotSpeed: π / 3)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Overriden update
    override func update(dt: CGFloat)
    {
        super.update(dt)
        
        //Decrement fire rate counter based on a given delta time
        fireRateCounter -= dt;
        if(fireRateCounter < 0)
        {
            fireRateCounter = 0;
        }
    }
    
    //Get if the guns are ready to fire
    func getGunsReady() -> Bool
    {
        return fireRateCounter > 0
    }
    
    //Get an array of the positions of the guns.
    func getGuns() -> [CGPoint]
    {
        fireRateCounter = fireRate
        
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
}
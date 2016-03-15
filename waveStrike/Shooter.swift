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
}
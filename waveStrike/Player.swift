import SpriteKit

class Player : Ship
{
    var spacc: CGFloat  //Scalar acceleration value
    
    init()
    {
        spacc = 60.0
        let texture = SKTexture(imageNamed: "ship_medium_body")
        super.init(
            texture: texture,
            position: CGPoint(x: 0, y: 0),
            maxSpeed: 540,
            rotSpeed: π / 3)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getGuns() -> [CGPoint]
    {
        let points: [CGPoint] =
            [
                CGPoint(x: self.position.x, y: self.position.y) +
                CGPoint(x: 50 * sin(self.zRotation), y: 50 * cos(self.zRotation)),
                
                CGPoint(x: self.position.x, y: self.position.y) +
                CGPoint(x: -50 * sin(self.zRotation), y: -50 * cos(self.zRotation)),
                
                CGPoint(x: self.position.x, y: self.position.y) +
                CGPoint(x: 50 * sin(self.zRotation), y: 50 * cos(self.zRotation)),
                
                CGPoint(x: self.position.x, y: self.position.y) +
                CGPoint(x: -50 * sin(self.zRotation), y: -50 * cos(self.zRotation)),
            ]
        return points
    }
}
import SpriteKit

class Target : Ship
{
    init(boundary: CGRect)
    {
        let texture = SKTexture(imageNamed: "ship_small_body")
        super.init(
            texture: texture,
            position: CGPoint(
                x: CGFloat.random(
                    min: boundary.minX,
                    max: boundary.maxX),
                y: CGFloat.random(
                    min: boundary.minY,
                    max: boundary.maxY)),
            maxSpeed: 0,
            rotSpeed: π / 2)
        self.zRotation = CGFloat.random(min: 0, max: 2 * π)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
import SpriteKit

class Player : Ship
{
    init()
    {
        let texture = SKTexture(imageNamed: "ship_medium_body")
        super.init(
            texture: texture,
            position: CGPoint(x: 0, y: 0),
            maxSpeed: 480,
            rotSpeed: π / 8)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
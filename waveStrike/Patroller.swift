import SpriteKit

class Patroller : Enemy
{
    init(position: CGPoint, velocityDir: CGPoint)
    {
        super.init(
            position: position,
            velocity: velocityDir * 80,
            maxSpeed: 80,
            rotSpeed: π / 3,
            texture: SKTexture(imageNamed: Constants.Image.TargetImage1))
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
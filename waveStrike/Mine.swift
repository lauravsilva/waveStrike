import SpriteKit

//Mine enemy. Does not move, but causes damage
class Mine : Enemy
{
    init(position: CGPoint)
    {
        super.init(
            position: position,
            velocity: CGPoint(x: 0, y: 0),
            maxSpeed: 0,
            rotSpeed: 0,
            texture: SKTexture(imageNamed: Constants.Image.TargetImage3))
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
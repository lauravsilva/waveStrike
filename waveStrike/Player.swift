import SpriteKit

class Player : SKSpriteNode
{
    init()
    {
        let texture = SKTexture(imageNamed: "ship_medium_body")
        super.init(texture: texture, color: UIColor(), size: texture.size())
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
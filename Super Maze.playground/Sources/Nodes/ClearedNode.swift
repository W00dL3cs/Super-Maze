import SpriteKit
import Foundation

public class ClearedNode: SKSpriteNode
{
    private var instance:GameScene!
    
    private var nextButton:SKSpriteNode!
    
    public init(parent:GameScene)
    {
        self.instance = parent
        
        let texture = SKTexture(imageNamed: "level-cleared")
        
        super.init(texture: texture, color: .clear, size: .zero)
        
        self.zPosition = 100
        self.isUserInteractionEnabled = true
        
        self.size = CGSize(width: parent.frame.height / 2.5, height: parent.frame.width / 3.5)
        self.position = CGPoint(x: parent.frame.midX, y: parent.frame.midY)
        
        self.nextButton = SKSpriteNode(imageNamed: "forward-button")
        self.nextButton.zPosition = 101
        self.nextButton.size = CGSize(width: size.height / 4, height: size.height / 4)
        self.nextButton.position = CGPoint(x: 0, y: -(size.height / 2))
        
        addChild(nextButton)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touches.first
        {
            let location = touch.location(in: self)
            
            if nextButton.contains(location)
            {
                self.removeFromParent()
                
                instance.move(toScene: .play)
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}

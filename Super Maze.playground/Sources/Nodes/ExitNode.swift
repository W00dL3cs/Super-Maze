import SpriteKit
import Foundation

public class ExitNode: SKSpriteNode
{
    private var instance:GameScene!
    
    private var confirmButton:SKSpriteNode!
    private var cancelButton:SKSpriteNode!
    
    public init(parent:GameScene)
    {
        self.instance = parent
        
        let texture = SKTexture(imageNamed: "UI/exit")
        
        super.init(texture: texture, color: .clear, size: .zero)
        
        self.zPosition = 1000
        self.isUserInteractionEnabled = true
        
        self.size = CGSize(width: parent.frame.height / 2.5, height: parent.frame.width / 3.5)
        self.position = CGPoint(x: parent.frame.midX, y: parent.frame.midY)
        
        self.confirmButton = SKSpriteNode(imageNamed: "UI/confirm-button")
        self.confirmButton.size = CGSize(width: size.height / 4, height: size.height / 4)
        self.confirmButton.position = CGPoint(x: -confirmButton.size.width, y: -(size.height / 2))
        
        self.cancelButton = SKSpriteNode(imageNamed: "UI/cancel-button")
        self.cancelButton.size = self.confirmButton.size
        self.cancelButton.position = CGPoint(x: cancelButton.size.width, y: -(size.height / 2))
        
        addChild(confirmButton)
        addChild(cancelButton)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touches.first
        {
            let location = touch.location(in: self)
            
            if confirmButton.contains(location)
            {
                instance.move(toScene: .homepage)
            }
            else if cancelButton.contains(location)
            {
                removeFromParent()
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}

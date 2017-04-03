import SpriteKit
import Foundation

public class TopBarNode: SKSpriteNode
{
    private var instance:GameScene!
    
    private var menuButton:SKSpriteNode!
    private var helpButton:SKSpriteNode!
    
    private var exitNode:ExitNode?
    
    public init(parent:GameScene)
    {
        self.instance = parent
        
        let texture = SKTexture(imageNamed: "toolbar")
        
        super.init(texture: texture, color: .clear, size: .zero)
        
        self.anchorPoint = .zero
        self.isUserInteractionEnabled = true
        
        self.size = CGSize(width: parent.frame.width - (parent.frame.width / 5), height: parent.frame.height / 12)
        self.position = CGPoint(x: parent.frame.midX - (size.width / 2), y: parent.frame.height - frame.height - 15)
        
        self.menuButton = SKSpriteNode(imageNamed: "UI/menu-button")
        self.menuButton.size = CGSize(width: size.height / 2, height: size.height / 2)
        self.menuButton.position = CGPoint(x: frame.origin.x, y: self.menuButton.frame.midY + (frame.height / 2.8))
        
        self.helpButton = SKSpriteNode(imageNamed: "UI/help-button")
        self.helpButton.size = self.menuButton.size
        self.helpButton.position = CGPoint(x: frame.size.width - frame.origin.x, y: self.menuButton.position.y)
        
        addChild(menuButton)
        addChild(helpButton)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touches.first
        {
            let location = touch.location(in: self)
            
            if menuButton.contains(location)
            {
                if exitNode == nil
                {
                    exitNode = ExitNode(parent: instance)
                }
                
                instance.addChild(exitNode!)
            }
            else if helpButton.contains(location)
            {
                instance.showHints()
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}

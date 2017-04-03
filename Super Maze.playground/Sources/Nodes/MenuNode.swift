import Foundation
import SpriteKit

public class MenuNode : SKSpriteNode
{
    private var instance:GameScene!
    
    private var playButton:SKSpriteNode!
    private var aboutButton:SKSpriteNode!
    private var backButton:SKSpriteNode!
    
    private var aboutNode:SKSpriteNode?
    
    private var sceneType:SceneType!
    
    public init(parent:GameScene)
    {
        self.instance = parent
        
        let texture = SKTexture(imageNamed: "UI/home")
        
        self.sceneType = .homepage
        
        super.init(texture: texture, color: .clear, size: .zero)
        
        self.isUserInteractionEnabled = true
        
        self.size = CGSize(width: parent.frame.width * 2/3, height: parent.frame.height / 3)
        self.position = CGPoint(x: parent.frame.midX, y: parent.frame.midY)
        
        self.playButton = SKSpriteNode(imageNamed: "UI/play-button")
        self.playButton.size = CGSize(width: frame.width - (frame.width / 4), height: frame.height / 5)
        
        self.aboutButton = SKSpriteNode(imageNamed: "UI/about-button")
        self.aboutButton.size = playButton.size
        self.aboutButton.position = CGPoint(x: 0, y: -(aboutButton.size.height + aboutButton.size.height / 4))
        
        addChild(playButton)
        addChild(aboutButton)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touches.first
        {
            let location = touch.location(in: self)
            
            if (sceneType == .homepage)
            {
                if playButton.contains(location)
                {
                    playButton.texture = SKTexture(imageNamed: "UI/play-button-highlighted")
                }
                else if aboutButton.contains(location)
                {
                    if aboutNode == nil
                    {
                        aboutNode = SKSpriteNode(imageNamed: "UI/about")
                        
                        aboutNode!.size = frame.size
                        
                        backButton = SKSpriteNode(imageNamed: "UI/back-button")
                        backButton.size = CGSize(width: aboutNode!.size.height / 4, height: aboutNode!.size.height / 4)
                        backButton.position = CGPoint(x: 0, y: -(aboutNode!.size.height / 2))
                        
                        aboutNode?.addChild(backButton)
                    }
                    
                    aboutButton.texture = SKTexture(imageNamed: "UI/about-button-highlighted")
                }
            }
            else
            {
                sceneType = .homepage
                
                aboutNode?.removeFromParent()
            }
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touches.first
        {
            let location = touch.location(in: self)
            
            if (sceneType == .homepage)
            {
                if playButton.contains(location)
                {
                    instance.move(toScene: .play)
                    
                    playButton.texture = SKTexture(imageNamed: "UI/play-button")
                }
                else if aboutButton.contains(location)
                {
                    self.sceneType = .about
                    
                    addChild(aboutNode!)
                    
                    aboutButton.texture = SKTexture(imageNamed: "UI/about-button")
                }
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}

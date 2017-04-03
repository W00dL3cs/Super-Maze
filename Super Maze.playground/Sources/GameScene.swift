import SpriteKit
import Foundation
import CoreMotion
import AVFoundation

public enum CollisionType : UInt32
{
    case player = 1
    case end = 2
}

public enum SceneType
{
    case homepage
    case about
    case play
    case nextlevel
}

public class GameScene : SKScene, SKPhysicsContactDelegate
{
    public var menuNode:MenuNode?
    public var mazeNode:MazeNode?
    public var nextLevelNode:ClearedNode?
    
    private var motion:CMMotionManager!
    
    private var sceneType:SceneType = .homepage
    
    override public func didMove(to view: SKView)
    {
        // Update current scene size
        self.size = view.frame.size
        
        //playMusic()
        
        // Call our main function
        start()
    }
    
    private func playMusic()
    {
        let action = SKAction.repeatForever(SKAction.playSoundFileNamed("music", waitForCompletion: true))
        
        run(action)
    }
    
    public func move(toScene scene:SceneType)
    {
        self.sceneType = scene
        
        reset()
    }
    
    func reset()
    {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        if (physicsWorld.contactDelegate == nil)
        {
            physicsWorld.contactDelegate = self
        }
        
        removeAllChildren()
        
        start()
    }
    
    func start()
    {
        if sceneType == .homepage
        {
            if menuNode == nil
            {
                menuNode = MenuNode(parent: self)
            }
            
            addChild(menuNode!)
        }
        else if sceneType == .play
        {
            mazeNode = MazeNode(parent: self)
            
            if motion == nil
            {
                motion = CMMotionManager()
                motion.startAccelerometerUpdates()
            }
            
            addChild(mazeNode!)
        }
    }
    
    override public func update(_ currentTime: TimeInterval)
    {
        if mazeNode != nil
        {
            if let data = motion.accelerometerData
            {
                physicsWorld.gravity = CGVector(dx: data.acceleration.x * 20, dy: data.acceleration.y * 20)
            }
        }
    }
    
    func drawScore()
    {
        sceneType = .nextlevel
        
        let effectNode = SKEffectNode()
        
        let blur = CIFilter(name:"CIGaussianBlur",withInputParameters: ["inputRadius": 10.0]);
        effectNode.filter = blur;
        effectNode.shouldRasterize = true;
        effectNode.shouldEnableEffects = true;
        
        let world = self.children
        self.removeAllChildren()
        
        for node in world
        {
            effectNode.addChild(node)
        }
        
        if (nextLevelNode == nil)
        {
            nextLevelNode = ClearedNode(parent: self)
        }
        
        addChild(effectNode)
        addChild(nextLevelNode!)
    }
    
    public func showHints()
    {
        if let mazeNode = mazeNode
        {
            mazeNode.solve()
        }
    }
    
    public func didBegin(_ contact: SKPhysicsContact)
    {
        if (contact.bodyA.node?.name == "ball")
        {
            handleCollision(player: contact.bodyA.node!, with: contact.bodyB.node!)
        }
        else if (contact.bodyB.node?.name == "ball")
        {
            handleCollision(player: contact.bodyB.node!, with: contact.bodyA.node!)
        }
    }
    
    private func handleCollision(player: SKNode, with body: SKNode)
    {
        if (body.frame.origin.x > 0 && body.frame.origin.y > 0)
        {
            if (body.name == "end" && player.name == "ball")
            {
                player.physicsBody?.isDynamic = false
                
                let move = SKAction.move(to: CGPoint(x: body.position.x, y: body.position.y + (body.frame.size.height / 4)), duration: 0.25)
                let scale = SKAction.scale(to: 0.0001, duration: 0.25)
                let remove = SKAction.removeFromParent()
                let sequence = SKAction.sequence([move, scale, remove])
                
                player.run(sequence, completion:
                {
                        self.drawScore()
                })
            }
        }
    }
}

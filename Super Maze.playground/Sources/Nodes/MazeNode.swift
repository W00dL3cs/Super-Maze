import SpriteKit
import Foundation

public class MazeNode : SKSpriteNode
{
    private var instance:GameScene!
    private var toolbar:TopBarNode!
    
    private var maze:Map!
    private var solution:[Node]?
    
    private var spawn:CGPoint?
    
    private var player:SKSpriteNode!
    
    public init(parent:GameScene)
    {
        self.instance = parent
        
        let texture = SKTexture(imageNamed: "background")
        
        super.init(texture: texture, color: .clear, size: instance.frame.size)
        
        self.anchorPoint = .zero
        
        self.isUserInteractionEnabled = true
        
        self.toolbar = TopBarNode(parent: parent)
        
        addChild(self.toolbar)
        
        generate()
        
        draw()
        
        createPlayer()
    }
    
    public func solve()
    {
        if let drawableRect = maze.drawableRect, let nodeSize = maze.nodeSize, let path = solution
        {
            var points = [CGPoint]()
            
            for node in path
            {
                let x = drawableRect.origin.x + (CGFloat(node.x) * nodeSize) + (nodeSize / 2)
                let y = drawableRect.height + drawableRect.origin.y - (CGFloat(node.y) * nodeSize) - (nodeSize / 2)
                
                points.append(CGPoint(x: x, y: y))
            }
            
            let shape = SKShapeNode(points: &points, count: points.count)
            shape.lineWidth = nodeSize * 0.2
            shape.zPosition = 0
            
            let fadeOut = SKAction.fadeAlpha(to: 0, duration: 1)
            let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
            let sequence = SKAction.repeat(SKAction.sequence([fadeOut, fadeIn]), count: 2)
            
            self.addChild(shape)
            
            shape.run(sequence, completion:
            {
                shape.removeFromParent()
            })
        }
    }
    
    private func generate()
    {
        while (true)
        {
            let random = Map.generate()
            
            let solver = Pathfinder(map: random)
            
            if let (path, _, _) = solver.calculate()
            {
                // Difficulty check
                //if path.count < 5
                if path.count >= (random.height + random.width) * 2
                {
                    self.maze = random
                    
                    self.solution = path
                    
                    return
                }
            }
        }
    }
    
    private func draw()
    {
        let drawableRect = CGRect(x: 0, y: 60, width: self.frame.width, height: self.frame.height - self.toolbar.startY() - 60)
        
        // TODO: Support for toolbar?
        maze.resizeAccordingTo(frame: drawableRect)
        
        if let nodeSize = maze.nodeSize, let drawableRect = maze.drawableRect
        {
            for row in 0..<maze.height
            {
                for column in 0..<maze.width
                {
                    if let node = maze.get(x: column, y: (maze.height - (row + 1)))
                    {
                        let patch = SKSpriteNode(imageNamed: node.patch.description)
                        patch.zPosition = 0
                        patch.position = CGPoint(x: drawableRect.origin.x + (nodeSize * CGFloat(column)), y: drawableRect.origin.y + (nodeSize * CGFloat(row)))
                        patch.position.y += (nodeSize / 2)
                        patch.position.x += (nodeSize / 2)
                        patch.size = CGSize(width: nodeSize, height: nodeSize)
                        
                        addChild(patch)
                        
                        if (row == 0 || row == maze.height - 1 || column == 0 || column == maze.width - 1)
                        {
                            patch.isHidden = true
                            
                            patch.physicsBody = SKPhysicsBody(circleOfRadius: (nodeSize / 2), center: CGPoint(x: 0, y: (nodeSize / 2)))
                            patch.physicsBody!.isDynamic = false
                        }
                        else if (node.type == .obstacle)
                        {
                            let node = SKSpriteNode(imageNamed: "prop-tree-5")
                            node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
                            node.position = patch.position
                            node.position.y -= (nodeSize / 2)
                            node.zPosition = CGFloat(maze.height - row)
                            node.size = CGSize(width: nodeSize, height: nodeSize * 2)
                            
                            node.physicsBody = SKPhysicsBody(circleOfRadius: (nodeSize / 2), center: CGPoint(x: 0, y: (nodeSize / 2)))
                            node.physicsBody!.isDynamic = false
                            
                            addChild(node)
                        }
                        else if (node.type == .start || node.type == .end)
                        {
                            let warp = SKSpriteNode(imageNamed: "prop-warp-1")
                            warp.anchorPoint = CGPoint(x: 0.5, y: 0.0)
                            warp.position = patch.position
                            warp.position.y -= (nodeSize / 2)
                            warp.zPosition = 0
                            warp.size = CGSize(width: nodeSize, height: nodeSize * 2)
                            
                            if (node.type == .start)
                            {
                                spawn = patch.position
                            }
                            else
                            {
                                warp.name = "end"
                                
                                warp.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: warp.size.width, height: nodeSize), center: CGPoint(x: 0, y: (nodeSize / 2)))
                                warp.physicsBody!.isDynamic = false
                                warp.physicsBody!.categoryBitMask = CollisionType.end.rawValue
                                warp.physicsBody!.contactTestBitMask = CollisionType.player.rawValue
                                
                                let glowNode : SKSpriteNode = warp.copy() as! SKSpriteNode
                                glowNode.size = warp.size
                                glowNode.position = CGPoint(x: 0, y: 0)
                                glowNode.anchorPoint = warp.anchorPoint
                                glowNode.alpha = 0.5
                                glowNode.blendMode = .add
                                //create the skaction loop that fades in and out
                                let fadeOut = SKAction.fadeAlpha(to: 0, duration: 1)
                                let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
                                let forever = SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn]))
                                glowNode.run(forever)
                                
                                // add the new node to the original node
                                warp.addChild(glowNode)
                            }
                            
                            addChild(warp)
                        }
                    }
                }
            }
        }
    }
    
    private func createPlayer()
    {
        if let spawn = spawn, let nodeSize = maze.nodeSize
        {
            player = SKSpriteNode(imageNamed: "ball")
            
            player.name = "ball"
            player.position = spawn
            player.zPosition = 0
            player.position.y += (nodeSize / 3)
            player.size = CGSize(width: nodeSize, height: nodeSize)
            
            player.physicsBody = SKPhysicsBody(circleOfRadius: (player.size.width / 2))
            player.physicsBody!.linearDamping = 0.5
            player.physicsBody!.allowsRotation = true
            player.physicsBody!.categoryBitMask = CollisionType.player.rawValue
            player.physicsBody!.contactTestBitMask = CollisionType.end.rawValue
            player.physicsBody!.collisionBitMask = CollisionType.end.rawValue
            
            addChild(player)
        }
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}

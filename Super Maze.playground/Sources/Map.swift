import UIKit
import Foundation

public class Map
{
    public var graph = [[Node]]()
    
    var startNode:Node!
    var endNode:Node!
    
    var nodeSize:CGFloat?
    var drawableRect:CGRect?
    
    private init() { }
    
    private static func carve(maze:Map, startNode:Node)
    {
        let upx = [1, -1, 0, 0]
        let upy = [0, 0, 1, -1]
        var dir = Int(arc4random_uniform(4))
        var count = 0
        
        while count < 4
        {
            let x1 = startNode.x + upx[dir]
            let y1 = startNode.y + upy[dir]
            let x2 = x1 + upx[dir]
            let y2 = y1 + upy[dir]
            
            if let node1 = maze.get(x: x1, y: y1), let node2 = maze.get(x: x2, y: y2)
            {
                if node1.type == .obstacle && node2.type == .obstacle
                {
                    node1.type = .walkable
                    node2.type = .walkable
                    
                    carve(maze: maze, startNode: node2)
                }
                else
                {
                    dir = (dir + 1) % 4
                    count += 1
                }
            }
        }
    }
    
    public static func generate() -> Map
    {
        let result = Map()
        
        let randomWidth = Utils.randomOddValue(min: 19, max: 33)
        let randomHeight = Utils.randomOddValue(min: randomWidth, max: Int(Double(randomWidth) * 1.7))
        
        let randomPatch = PatchType.random()
        
        // Step 1: Fill our matrix with placeholder obstacles
        for row in 0..<randomHeight
        {
            var currentRow = [Node]()
            
            for column in 0..<randomWidth
            {
                let node = Node(x: column, y: row, type: .obstacle, patch: randomPatch)
                
                currentRow.append(node)
            }
            
            result.graph.append(currentRow)
        }
        
        // Step 2: Set the external borders of the maze as walkable
        for i in 0 ..< randomWidth
        {
            result.graph[0][i].type = .walkable
            result.graph[randomHeight - 1][i].type = .walkable
        }
        
        for i in 0 ..< randomHeight
        {
            result.graph[i][0].type = .walkable
            result.graph[i][randomWidth - 1].type = .walkable
        }
        
        // Step 3: Set the maze entry and exit nodes
        let startNode = result.graph[Utils.randomOddValue(min: 1, max: randomHeight - 1)][Utils.randomEvenValue(min: 1, max: randomWidth - 1)]
        let endNode = result.graph[Utils.randomEvenValue(min: 1, max: randomHeight - 2)][Utils.randomOddValue(min: 1, max: randomWidth - 1)]
        
        startNode.type = .start
        endNode.type = .end
        
        result.startNode = startNode
        result.endNode = endNode
        
        // Choose the first step used for maze carving
        let firstNode = result.graph[startNode.y + 1][startNode.x]
        
        //firstNode.type = .walkable
        
        // Step 4: Carve the maze
        carve(maze: result, startNode: firstNode)
        
        // Step 5: Randomly remove obstacles in order to create multiple paths and increase difficulty
        let walkable = result.graph.flatMap
        {
            $0.filter
            {
                $0.type == .obstacle && ($0.x > 1 && $0.x < (randomWidth - 2)) && ($0.y > 1 && $0.y < (randomHeight - 2))
            }
        }
        
        for i in 0..<arc4random_uniform(UInt32(sqrt(Double(walkable.count))))
        {
            walkable[Int(arc4random_uniform(UInt32(walkable.count)))].type = .walkable
        }
        
        // Set the last step as walkable
        let lastNode = result.graph[randomHeight - 3][endNode.x]
        
        lastNode.type = .walkable
        
        // Set the external borders of the maze as non-walkable once again
        result.graph[0].map
        {
            $0.type = .obstacle
        }
        
        return result
    }
    
    public func resizeAccordingTo(frame:CGRect)
    {
        let mapRatio = CGFloat(width) / CGFloat(height)
        let viewRatio = frame.width / frame.height
        
        if mapRatio < viewRatio
        {
            // The map is wider than the view
            
            let mapHeight = frame.height - 20
            let mapWidth = mapHeight * mapRatio
            
            drawableRect = CGRect(x: frame.origin.x + (frame.width - mapWidth) / 2, y: frame.origin.y + (frame.height - mapHeight) / 2, width: mapWidth, height: mapHeight)
        }
        else
        {
            // The map is taller than the view
            
            let mapWidth = frame.width - 10
            let mapHeight = mapWidth / mapRatio
            
            drawableRect = CGRect(x: frame.origin.x + (frame.width - mapWidth) / 2, y: frame.origin.y + (frame.height - mapHeight) / 2, width: mapWidth, height: mapHeight)
        }
        
        nodeSize = (drawableRect!.width) / CGFloat(width)
    }
    
    public func get(x:Int, y:Int) -> Node?
    {
        if (x >= 0 && x < width) && (y >= 0 && y < height)
        {
            return graph[y][x]
        }
        
        return nil
    }
    
    public var height:Int
    {
        return graph.count
    }
    
    public var width:Int
    {
        if (height > 0)
        {
            return graph[0].count
        }
        
        return 0
    }
}

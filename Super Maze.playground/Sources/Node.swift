import Foundation

public enum PatchType : String, CustomStringConvertible
{
    case grass_1
    case grass_2
    case grass_3
    case grass_4
    
    case snow_1
    case snow_2
    case snow_3
    
    case stone_1
    
    public var description: String
    {
        return "floors/patch-\(self.rawValue.replacingOccurrences(of: "_", with: "-"))"
    }
    
    static func random() -> PatchType
    {
        let allValues:[PatchType] = [.grass_1, .grass_2, .grass_3, .grass_4]
        
        let index = Int(arc4random_uniform(UInt32(allValues.count)))
        
        return allValues[index]
    }
}

public enum NodeType : UInt32
{
    case obstacle
    case walkable
    
    case start
    case end
}

public class Node : Equatable
{
    public let x:Int
    public let y:Int
    public var type:NodeType
    public var patch:PatchType
    
    var parent:Node?
    var children = [Node]()
    
    var g:Int32?
    var h:Int32?
    var f:Int32?
    {
        if let h = h, let g = g { return h + g }
        else { return nil }
    }
    
    public init(x:Int, y:Int, type:NodeType, patch: PatchType)
    {
        self.x = x
        self.y = y
        
        self.type = type
        self.patch = patch
    }
    
    // Represents the cost from some node TO this node
    var cost: Int32
    {
        switch type
        {
            case .start, .end, .walkable:
                return 1
                
            case .obstacle:
                return -1
        }
    }
}

// Equatable implementation for Node
// Only checks if the coordinates, and the category are the same, as we will update the node over time, i.e attach-and-eval
public func ==(lhs: Node, rhs: Node) -> Bool
{
    return lhs.type == rhs.type && lhs.x == rhs.x && lhs.y == rhs.y
}

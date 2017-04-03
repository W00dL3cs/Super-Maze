import Foundation

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

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

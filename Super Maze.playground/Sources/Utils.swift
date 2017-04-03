import Foundation

public class Utils
{
    public static func randomOddValue(min:Int, max:Int) -> Int
    {
        var min = min
        var max = max
        
        if (min % 2 == 0)
        {
            min += 1
        }
        
        if (max % 2 == 0)
        {
            max -= 1
        }
        
        let range = (max - min + 1) / 2;
        
        return Int(arc4random_uniform(UInt32(range))) * 2 + min;
    }
    
    public static func randomEvenValue(min:Int, max:Int) -> Int
    {
        var min = min
        var max = max
        
        if (min % 2 == 1)
        {
            min += 1
        }
        
        if (max % 2 == 1)
        {
            max -= 1
        }
        
        let range = (max - min + 1) / 2;
        
        return Int(arc4random_uniform(UInt32(range))) * 2 + min;
    }
}

import Foundation

public extension Int {
    
    var roman: String? {
        guard 1 <= self, self <= 3999 else { return nil }
        
        let coding: [Int:String] = [1: "I", 4: "IV", 5:"V", 9:"IX", 10: "X", 40: "XL", 50: "L", 90: "XC", 100:"C", 400:"CD", 500: "D", 900: "CM", 1000:"M"]
        
        var result = ""
        var number = self
        
        for key in coding.keys.sorted(by: >) {
            while number >= key {
                number -= key
                result.append(coding[key]!)
            }
        }
        
        return result
    }
}

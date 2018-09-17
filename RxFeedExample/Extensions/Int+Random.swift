import Foundation

extension Int {

    static var random: Int {
        return Int.random(max: Int.max)
    }

    static func random(max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }

    static func random(min: Int, max: Int) -> Int {
        return Int.random(max: max - min + 1) + min
    }

}

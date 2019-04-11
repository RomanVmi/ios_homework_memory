import Foundation

struct Card {
    
    var isMatched = false
    var isFaceUp = false
    var id: Int
    var face: String
    
    static var lastIdentifier = -1
    static func getUniqueIdentifier() -> Int {
        lastIdentifier += 1
        return lastIdentifier
    }
    
    init() {
        self.id = Card.getUniqueIdentifier()
        self.face = ""
    }
    
}

import Foundation

class Memory {
    
    var cards = [Card]()

    var indexOfFaceUpCard: Int?
    
    func chooseCard(at index: Int) {
        if cards[index].isMatched {
            return
        }
        
        if let matchIndex = indexOfFaceUpCard, matchIndex != index {
            if cards[matchIndex].face == cards[index].face {
                cards[matchIndex].isMatched = true
                cards[index].isMatched = true
            }
            cards[index].isFaceUp = true
            indexOfFaceUpCard = nil
        } else {
            for cardIndex in cards.indices {
                cards[cardIndex].isFaceUp = false
            }
            cards[index].isFaceUp = true
            indexOfFaceUpCard = index
        }
    }
    
    init(numberOfCards: Int) {
        for _ in 1...numberOfCards {
            let card = Card()
            cards += [card]
        }
    }
    
}

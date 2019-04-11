import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet var startGameLabel: [UILabel]!
    @IBOutlet var restartButton: [UIButton]!
    
    lazy var game = Memory(numberOfCards: cardButtons.count)
    var gameIsActive = false
    
    // Генерация лицевой стороны для всех карт
    func generateFacesForCards() {
        let emojiList = ["🦊", "🐻", "🐼", "🐨", "🦁", "🐯", "🐵", "🦉", "🦇"]
        // изначально все карты пусты
        var cardsWithEmptyFace = Array(game.cards.indices.startIndex..<game.cards.indices.endIndex)
        
        fillFaces: for emoji in emojiList {
            // каждый смайл должен встречаться дважды
            for _ in 1...2 {
                // выбираем случайную карту и определяем ей смайл для лицевой стороны
                let card = cardsWithEmptyFace.randomElement()!
                game.cards[card].face = emoji
                cardsWithEmptyFace.remove(at: cardsWithEmptyFace.index(of: card)!)
            }
            // карт не осталось - заполнять больше не нужно
            if cardsWithEmptyFace.isEmpty {
                break fillFaces
            }
        }
    }
    
    // Поворот карты по индексу в ту или иную сторону
    func turnCardFace(at index: Int, to side: String) {
        let button = cardButtons[index]
        if (side == "front") {
            button.setTitle(game.cards[index].face, for: .normal)
            button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
            button.setTitle("", for: .normal)
            button.backgroundColor = #colorLiteral(red: 0.2723996043, green: 0.6819463372, blue: 0.632582128, alpha: 1)
        }
    }
    
    // Вызов функции поворота на определенную сторону для всех карт
    func turnAllCardsFaces(to side: String) {
        for cardIndex in cardButtons.indices {
            turnCardFace(at: cardIndex, to: side)
        }
    }

    // Начальные действия при старте игры
    func startGame() {
        gameIsActive = false
        generateFacesForCards()
        // через пару секунд после запуск показываем лэйбл и открываем все карты
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.startGameLabel[0].isHidden = false
            self.turnAllCardsFaces(to: "front")
        })
        // по истечению 6 секунд скрываем лэйбл и закрываем карты
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
            self.startGameLabel[0].isHidden = true
            self.turnAllCardsFaces(to: "back")
            self.gameIsActive = true
        })
    }
    
    // Рестарт игры
    func resetGame() {
        turnAllCardsFaces(to: "back")
        for cardIndex in cardButtons.indices {
            game.cards[cardIndex].isMatched = false
            game.cards[cardIndex].isFaceUp = false
        }
        restartButton[0].isEnabled = false
        startGame()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }
    
    @IBAction func cardButtonAction(_ sender: UIButton) {
        if !gameIsActive {
            return
        }
        if let cardIndex = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardIndex)
            updateButtons()
        } else {
            print("This button is not in card buttons!")
        }
    }
    
    @IBAction func restartButtonAction(_ sender: Any) {
        resetGame()
    }
    
    func updateButtons() {
        // если не осталось нерасрытых карт - активируем кнопку рестарта
        var dontMatchYet = 0
        for index in cardButtons.indices {
            let card = game.cards[index]
            if !card.isMatched {
                dontMatchYet += 1
            }
            if card.isFaceUp {
                turnCardFace(at: index, to: "front")
            } else {
                if !card.isMatched {
                    turnCardFace(at: index, to: "back")
                }
            }
        }
        if (dontMatchYet == 0) {
            restartButton[0].isEnabled = true
        }
    }
}


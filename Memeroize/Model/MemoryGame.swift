//
//  MemoryGame.swift
//  Memeroize
//
//  Game Model:
//      - CardContent is a 'don't care' type
//        so it can be anything.
//      - No longer has a free init
//
//  Created by Barrs, Mindy on 2023-02-03.
//

import Foundation

// Changes from a don't care to a kinda care
struct MemoryGame<CardContent> where CardContent: Equatable {
    private (set) var cards: Array<Card>
    private (set) var score: Int
    
    // An Optional Var and a computed property w/ get and set
    private var indexOfToOneAndOnlyCard: Int? {
        get { return cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        
        // 'cards.indices' return the range 0..cards.count
        set { cards.indices.forEach{ cards[$0].isFaceUp = ($0 ==  newValue) } }
    }
    
    // can only be called in viewModel with a 'var'
    mutating func chooseCard(selectedCard: Card){
        //   if let selectedIndex = index(of: selectedCard) { <- Original
        if let selectedIndex = cards.firstIndex(where: { $0.id == selectedCard.id }), !cards[selectedIndex].isFaceUp,
            !cards[selectedIndex].isAMatch
        {
            if let potentialMatchIndex = indexOfToOneAndOnlyCard {
                if cards[selectedIndex].content == cards[potentialMatchIndex].content {
                    cards[selectedIndex].isAMatch = true
                    cards[potentialMatchIndex].isAMatch = true
                }
                cards[selectedIndex].isFaceUp = true
            } else {
                
                
                indexOfToOneAndOnlyCard = selectedIndex
            }
        }
        
        // choosenCard.isFaceUp.toggle() is a copy of the array and so it will not update the array
        // Good for degugging and confirming this work
        // print("\(cards)")
    }
    
    // Second arg of the `init` is a fucntion that takes in an int and returns a 'CardContent'
    init(numberOfPairOfCards: Int, theme: (ThemeCollection.Theme), createCardContent: (Int) -> CardContent){
        cards = []
        score = 0
        
        // Add the numberOfPairOfCards x 2 card to cards arrary
        for pairIndex in 0..<numberOfPairOfCards {
            // Type is infereed by the return of the fucntion
            let content = createCardContent(pairIndex)
            
            cards.append(Card(id: pairIndex*2, content: content, selectedTheme: theme))
            cards.append(Card(id: pairIndex*2+1, content: content, selectedTheme: theme))
        }
        
        cards.shuffle()
    }
    
    func getScore() -> Int {
        return score
    }
    
    mutating func shuffle () {
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        let id: Int
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isAMatch = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        let content: CardContent
        let selectedTheme: ThemeCollection.Theme
        
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isAMatch && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isAMatch && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}


// All extensions have to be computed
extension Array {
    // An Array's don't care
    var oneAndOnly: Element? {
        if self.count == 1 {
            return self.first
        } else {
            return nil
        }
    }
}

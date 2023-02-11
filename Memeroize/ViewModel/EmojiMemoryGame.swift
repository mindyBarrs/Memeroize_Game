//
//  EmojiMemoryGame.swift
//  Memeroize
//
//  Game ViewModel
//
//  Created by Barrs, Mindy on 2023-02-03.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>
    typealias Card = MemoryGame<String>.Card
    
    var theme: ThemeCollection.Theme
    
    init(theme: ThemeCollection.Theme) {
        self.theme = theme
        model = EmojiMemoryGame.createMemoryCardGame(theme: theme)
        
    }

    // Type Function
    private static func createMemoryCardGame(theme: ThemeCollection.Theme) -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairOfCards: 6, theme: theme) { pairIndex in theme.emojis[pairIndex] }
        //MemoryGame<String>(numberOfPairOfCards: theme.emojis.count) { pairIndex in theme.emojis[pairIndex] }
    }

    // This allows the cards to be puclic and usable by the view
    var cards: Array<Card> {
        return model.cards
    }
    
    // MARK: - Intent(s)
    func choose(_ card:  Card) {
        model.chooseCard(selectedCard: card)
    }
    
    func newGame() {
        let newTheme = DefaultThemes.get
        self.theme = newTheme
        model = EmojiMemoryGame.createMemoryCardGame(theme: newTheme)
        model.shuffle()
    }
    
    func getScore() -> Int {
        return model.getScore()
    }
    
    func shuffle() {
        return model.shuffle()
    }
}

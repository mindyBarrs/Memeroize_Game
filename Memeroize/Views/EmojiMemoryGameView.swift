//
//  EmojiMemoryGameView.swift
//  Memeroize
//
//  View
//
//  Created by Barrs, Mindy on 2023-02-01.
//

import SwiftUI

/*
 * This struct fucntions behaves like
 *  a view. All are immutable.
 */
struct EmojiMemoryGameView: View {
    @ObservedObject var gameViewModel: EmojiMemoryGame
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        VStack {
            gameHeader
            gameBody
            deckBody
            gameFooter
        }.padding()
    }
    
    var gameHeader: some View {
        HStack() {
            Text("Memeroize !")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Text("Score: \(gameViewModel.getScore())")
                .fontWeight(.bold)
        }.padding().foregroundColor(Color("PrimaryColor"))
    }

    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUnDealt(_ card: EmojiMemoryGame.Card) -> Bool {
       !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        
        if let index = gameViewModel.cards.firstIndex(where: { $0.id == card.id}) {
            delay = Double(index) * (CardContants.totalDealDuration / Double(gameViewModel.cards.count))
        }
        
        return Animation.easeIn(duration: CardContants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(gameViewModel.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: gameViewModel.cards, aspectRatio: CardContants.aspectRatio) { card in
            if isUnDealt(card) || (card.isAMatch && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
//                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                         withAnimation() {
                             gameViewModel.choose(card)
                         }
                    }
            }
        }
        .foregroundColor(Color(gameViewModel.theme.themeColor))
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(gameViewModel.cards.filter(isUnDealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
//                    .zIndex(zIndex(of: card))
            }
        }
        .foregroundColor(Color(gameViewModel.theme.themeColor))
        .frame(width: CardContants.unDealWidth, height: CardContants.unDealHeight )
        .onTapGesture {
            for card in gameViewModel.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
        
    }
    
    var gameFooter: some View {
        HStack {
            Button {} label: {
                VStack {
                    Image(systemName: "gearshape").font(.largeTitle)
                    Text("\(gameViewModel.theme.name)")
                }
            }
            Spacer()
            Button { withAnimation(.easeOut(duration: 2)) {
                dealt = [ ]
                gameViewModel.newGame()
            }
            } label: {
                VStack {
                    Image(systemName: "plus.square").font(.largeTitle)
                    Text("New Game").font(.headline)
                }
            }
        }.padding(.horizontal)
    }
    
    private struct CardContants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 5
        static let unDealHeight: CGFloat = 130
        static let unDealWidth: CGFloat = unDealHeight * aspectRatio
    }
}

/*
 *  Card Struct
 */
struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    var itAMatch = true
    
    @State private var animatedBonusRemaining: Double = 0

    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }.opacity(DrawingConstants.pieOpacity).padding(5)
                
                Text(card.content)
                    .rotationEffect(Angle(degrees: card.isAMatch && card.isFaceUp ? 360 : 0))
                    .animation(Animation.linear(duration: 5), value: true)
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp, theme: card.selectedTheme)
            
        })
    }
    
    private func scale(thatFits size: CGSize ) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize/DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontSize: CGFloat = 32
        static let fontScale: CGFloat = 0.70
        static let pieOpacity: CGFloat = 0.5
    }
}













/*
 *  To have multiple previews, just duplicate the
 *  ContentView()
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame(theme: DefaultThemes.get)

        return EmojiMemoryGameView(gameViewModel: game)
            .previewDisplayName("Dark View")
            .preferredColorScheme(.dark)
//        EmojiMemoryGameView(gameViewModel: game)
//            .previewDisplayName("Light View")
//            .preferredColorScheme(.light)
    }
}

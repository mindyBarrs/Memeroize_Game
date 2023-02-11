//
//  SplashScreenView.swift
//  Memeroize
//
//  Created by Barrs, Mindy on 2023-02-07.
//

import SwiftUI

struct SplashScreenView: View {
    let game = EmojiMemoryGame(theme: DefaultThemes.get)
    
    @State var isActive: Bool = false
    
    var body: some View {
        HStack {
            if self.isActive {
                EmojiMemoryGameView(gameViewModel: game)
            } else {
                VStack {
                    Text("Memeroize!")
                    Text("Loading ....")
                }.bold()
                 .font(.largeTitle)
                 .foregroundColor(Color("PrimaryColor"))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

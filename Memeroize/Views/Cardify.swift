//
//  Cardify.swift
//  Memeroize
//
//  View Modifier
//
//  Created by Barrs, Mindy on 2023-02-08.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation: Double // in degrees
    var selectedTheme: ThemeCollection.Theme

    init (isFaceUp: Bool, theme: ThemeCollection.Theme) {
        rotation = isFaceUp ? 0 : 180
        selectedTheme = theme
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue  }
    }

    func body(content: Content) -> some View {
        ZStack {
            // Local Var
            let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            
            if rotation < 90 {
                cardShape.fill().foregroundColor(.white)
                cardShape.strokeBorder(lineWidth: DrawingConstants.borderWidth)
            } else {
                cardShape.fill()
                Image(systemName: "\(selectedTheme.themeIcon)")
                    .foregroundColor(Color("SecondaryColor"))
                    .font(Font.system(size: DrawingConstants.fontSize))
            }
            
            content.opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle(degrees: rotation), axis: (0,1,0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let borderWidth: CGFloat = 4
        static let fontSize: CGFloat = 45
    }
}

extension View {
    func cardify(isFaceUp: Bool, theme: ThemeCollection.Theme) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp, theme: theme))
    }
}

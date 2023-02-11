//
//  ThemeCollection.swift
//  Memeroize
//
//  Created by Barrs, Mindy on 2023-02-06.
//

import Foundation

struct ThemeCollection: Codable {
    var themes = [Theme]()
    
    struct Theme: Identifiable, Codable {
        var id = UUID()
        var numOfPairs: Int
        var themeColor: String
        var name: String
        var themeIcon: String
        var themeIconColor: String
        var emojis: [String]
        
        init(themeColor: String, numOfPairs: Int, name: String, themeIcon: String, themeIconColor: String, emojis: [String]) {
            self.themeColor = themeColor
            self.numOfPairs = numOfPairs
            self.name = name
            self.themeIcon = themeIcon
            self.themeIconColor = themeColor
            self.emojis = emojis
        }
    }
    
    var json: Data? {
            return try? JSONEncoder().encode(self)
        }
        
        init?(json: Data?) { // failable
            if json != nil, let newThemeCollection = try? JSONDecoder().decode(ThemeCollection.self, from: json!) {
                self = newThemeCollection
            } else {
                return nil
            }
        }
    
    init() {
        self.themes = [DefaultThemes.weatherTheme, DefaultThemes.activitieTheme, DefaultThemes.spaceTheme]
    }
    
   
}

struct DefaultThemes {
    // Default Themes
   static let weatherTheme = ThemeCollection.Theme(
        themeColor: "PrimaryColor",
        numOfPairs: 32,
        name: "Weather Theme",
        themeIcon: "cloud.sun.rain",
        themeIconColor: "BlackColor",
        emojis:["🌫","💨", "☔️", "🌪", "☀️", "🌥", "🌨", "☃️", "🌩", "🌤", "🌦", "⛈", "🌧", "⛅️", "☁️", "🌈"]
    )
    
    static let activitieTheme = ThemeCollection.Theme(
        themeColor: "YellowColor",
        numOfPairs: 30,
        name: "Activities Theme",
        themeIcon: "figure.walk.circle",
        themeIconColor: "SecondaryColor",
        emojis: ["🏂","🏄🏼", "🤸🏻", "🧘🏼‍♀️", "🎿", "🥌", "🚵🏻‍♂️", "🚣🏾", "🤼‍♂️", "🏒", "⛹🏼", "🤾🏻", "🪁", "🛹", "🧗🏾", "🎯", "🛼"]
    )
    
    static let spaceTheme = ThemeCollection.Theme(
        themeColor: "DarkOrangeColor",
        numOfPairs: 32,
        name: "Space Theme",
        themeIcon: "moon.stars",
        themeIconColor: "BlackColor",
        emojis: ["🛸","🚀", "🛰", "👾", "👽", "🪐", "✨", "🌞", "🌛", "💫", "🌌", "🔭", "♐️", "🌠", "☄️", "🇺🇸"]
    )
    
    static let transportTheme = ThemeCollection.Theme(
        themeColor: "OrangeColor",
        numOfPairs: 20,
        name: "Transportation Theme",
        themeIcon: "car.circle",
        themeIconColor: "SecondaryColor",
        emojis: [ "🚕", "🚌", "✈️", "🚛", "🚂", "🚎", "🚁", "🛳", "🚝", "🚞", ])
    
    // Get Random Theme
    static var get: ThemeCollection.Theme {
        let allThemes = [ weatherTheme, activitieTheme, spaceTheme, transportTheme]
        return allThemes.randomElement()!
    }
}

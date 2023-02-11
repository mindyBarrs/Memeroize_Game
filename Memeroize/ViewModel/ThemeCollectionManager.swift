//
//  ThemeCollectionManager.swift
//  Memeroize
//
//  View Model
//
//  Created by Barrs, Mindy on 2023-02-06.
//

import Foundation

class ThemeCollectionManager: ObservableObject {
    @Published private var themeCollection: ThemeCollection {
           didSet {
               UserDefaults.standard.set(themeCollection.json, forKey: "theme-collection")
           }
       }
    
       init() {
           themeCollection = ThemeCollection(json: UserDefaults.standard.data(forKey: "theme-collection")) ?? ThemeCollection()
       }
       
       var themes: [ThemeCollection.Theme] { themeCollection.themes }
}

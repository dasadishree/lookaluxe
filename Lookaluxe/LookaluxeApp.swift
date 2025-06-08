//
//  LookaluxeApp.swift
//  Lookaluxe
//
//  Created by Adishree Das on 6/6/25.
//

import SwiftUI

@main

struct LookaluxeApp: App {
    init() {
        //sets global tint to brown
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.brown.withAlphaComponent(0.1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.brown]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.brown]
        appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.brown]
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.brown]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor.brown
        
    }
    
    var body: some Scene {
        WindowGroup {
//            calls content view (first screen)
            ContentView()
//                changes accent color? dk if it worked tho
                .accentColor(Color(red: 163/255, green: 107/255, blue: 67/255 ))
        }
    }
}

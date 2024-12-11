//
//  WeatherWiseApp.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 02/12/2024.
//

// this is the main where the app start
import SwiftUI

@main
struct WeatherWiseApp: App {
    init() {
        setupTabBarAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance() // created "appearance" variable
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        // customize normal state (inactive tabs)
        appearance.stackedLayoutAppearance.normal.iconColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]

        // customize selected state (active tab)
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

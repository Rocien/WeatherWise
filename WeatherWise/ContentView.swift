//
//  ContentView.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 02/12/2024.
//

import SwiftUI

// this is the entry point, whatever i added here remain in entire app.
struct ContentView: View {
    var body: some View {
        // creating tabBar to navigate between settings and cities
        TabView {
            CityListView() // this call citylistview page
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Cities")
                }

            SettingsView() // and this call the settings page
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    ContentView()
}

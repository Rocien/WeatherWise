//
//  SettingsView.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedInterval: Int = UserDefaults.standard.integer(forKey: "RefreshInterval") == 0 ? 15 : UserDefaults.standard.integer(forKey: "RefreshInterval")
    let refreshOptions = [5, 10, 15, 30, 60] // available options in minutes

    // app dark and light mode state
    @AppStorage("DarkModeEnabled") private var isDarkMode = false // syncing with global dark mode state

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Time Refresh Interval").foregroundStyle(.white)) {
                    Picker("Refresh Interval", selection: $selectedInterval) {
                        ForEach(refreshOptions, id: \.self) { option in
                            Text("\(option) minutes").tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedInterval, initial: true) { _, newValue in
                        UserDefaults.standard.set(newValue, forKey: "RefreshInterval")
                    }
                }

                Section(header: Text("About").foregroundStyle(.white)) {
                    NavigationLink(destination: AboutView()) {
                        Text("About the App")
                    }
                }

                Toggle("Dark Mode", isOn: $isDarkMode) // here it syncs with global state

                Spacer()
            }
            .background(
                Image("background-v2")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
        }
    }
}

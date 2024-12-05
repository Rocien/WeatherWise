//
//  SettingsView.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedInterval: Int = UserDefaults.standard.integer(forKey: "RefreshInterval") == 0 ? 15 : UserDefaults.standard.integer(forKey: "RefreshInterval")
    let refreshOptions = [5, 10, 15, 30, 60] // Available options in minutes

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Time Refresh Interval")) {
                    Picker("Refresh Interval", selection: $selectedInterval) {
                        ForEach(refreshOptions, id: \.self) { option in
                            Text("\(option) minutes").tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedInterval) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "RefreshInterval")
                    }
                }

                Section(header: Text("About")) {
                    NavigationLink(destination: AboutView()) {
                        Text("About the App")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

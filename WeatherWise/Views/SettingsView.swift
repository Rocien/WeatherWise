//
//  SettingsView.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedInterval: Int = 15 // added 15min as default refresh interval (in minutes)
    let refreshOptions = [5, 10, 15, 30, 60] // available options in minutes

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
                }

                // navigation link to the about page
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

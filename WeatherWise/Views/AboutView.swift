//
//  AboutView.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

import SwiftUI

// this is my about section where added my information
struct AboutView: View {
    @State private var showAlternateImage = false

    var body: some View {
        VStack {
            Text("WeatherWise")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            Text("Version 1.0")
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer().frame(height: 20)

            Text("Developed and Designed by Rocien Nkunga")
                .font(.body)

            Text("Copyright © 2024 Rocien Nkunga")
                .font(.caption)
                .foregroundColor(.gray)

            Spacer().frame(height: 20)

            Text("WeatherWise is a sleek and feature-rich weather app designed to provide users with accurate, real-time weather updates and forecasts. Developed by Rocien Nkunga, an experienced iOS, Flutter, and React Native developer, the app reflects a passion for crafting intuitive and visually appealing mobile experiences. WeatherWise empowers users with essential weather insights while showcasing a seamless blend of technology and design.")
                .font(.footnote)

            Spacer()

            // Display image with hidden feature
            Image(showAlternateImage ? "rocienProfile2" : "rocienProfile")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .scaleEffect(showAlternateImage ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: showAlternateImage)
                .onTapGesture(count: 3) {
                    showAlternateImage.toggle()
                }

            Spacer().frame(height: 20)

            // email x github and portfolio
            VStack(spacing: 10) {
                Text("Contact Me")
                    .font(.headline)

                // Email
                Text("contact@rociennkunga.com")
                    .foregroundColor(.blue)
                    .underline()
                    .onTapGesture {
                        // it will open mail app when tapped
                        if let url = URL(string: "mailto:contact@rociennkunga.com") {
                            UIApplication.shared.open(url)
                        }
                    }

                // GitHub
                Link("GitHub", destination: URL(string: "https://github.com/rocien")!)

                // Portfolio
                Link("Portfolio", destination: URL(string: "https://rociennkunga.com")!)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("About")
    }
}

//
//  WeatherDetailView.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 04/12/2024.
//

import SwiftUI

// created this component to separate the DetailView, this is for the Wind and Humidity only
struct WeatherDetailView: View {
    var icon: String
    var label: String
    var value: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(.white)
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.6))
        )
    }
}

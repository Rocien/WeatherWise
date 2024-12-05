//
//  CityDetailView.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 04/12/2024.
//

import MapKit
import SwiftUI

struct CityDetailView: View {
    var city: City
    @State private var weatherDetails: WeatherResponse?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            // Use MapView for the map background
            MapView(cityName: city.name)
                .ignoresSafeArea()

            if let weatherDetails = weatherDetails {
                VStack(alignment: .leading) {
                    Text(weatherDetails.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Temperature: \(Int(weatherDetails.main.temp))°C")
                        .font(.headline)
                        .foregroundColor(.white)

                    HStack {
                        WeatherDetailView(icon: "wind", label: "Wind", value: "\(weatherDetails.wind.speed) m/s")
                        WeatherDetailView(icon: "humidity", label: "Humidity", value: "\(weatherDetails.main.humidity)%")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.6))
                    )
                    .padding()

                    Spacer()
                }
                .padding()
            } else if isLoading {
                ProgressView("Loading weather details...")
                    .foregroundColor(.white)
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            fetchDetails()
        }
    }

    private func fetchDetails() {
        isLoading = true
        Task {
            await WeatherService().fetchWeather(for: city.name) { result in
                DispatchQueue.main.async {
                    isLoading = false
                    switch result {
                    case .success(let details):
                        weatherDetails = details
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}

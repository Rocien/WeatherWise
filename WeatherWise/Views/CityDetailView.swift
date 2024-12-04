//
//  CityDetailView.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 04/12/2024.
//

import MapKit
import SwiftUI

import SwiftUI

struct CityDetailView: View {
    var city: City
    @State private var weatherDetails: WeatherResponse?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            // map in the background
            MapView(cityName: city.name)
                .ignoresSafeArea()

            // overlay with weather details
            VStack {
                if let weatherDetails = weatherDetails {
                    // Display weather details when loaded
                    VStack(alignment: .leading) {
                        Text(city.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Temperature: \(Int(weatherDetails.main.temp))°C")
                            .font(.headline)
                            .foregroundColor(.white)

                        Spacer().frame(height: 20)

                        // weather details row
                        HStack {
                            WeatherDetailView(icon: "sun.max", label: "UV Index", value: "N/A")
                            WeatherDetailView(icon: "wind", label: "Wind", value: "\(weatherDetails.wind.speed) m/s")
                            WeatherDetailView(icon: "humidity", label: "Humidity", value: "\(weatherDetails.main.humidity)%")
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.6))
                    )
                    .padding()
                } else if isLoading {
                    ProgressView("Loading weather details...")
                        .foregroundColor(.white)
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
                Spacer()
            }
        }
        .onAppear {
            fetchDetails()
        }
    }

    private func fetchDetails() {
        Task {
            await WeatherService().fetchWeatherDetails(lat: city.coord.lat, lon: city.coord.lon) { result in
                DispatchQueue.main.async {
                    isLoading = false
                    switch result {
                    case .success(let details):
                        self.weatherDetails = details
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}

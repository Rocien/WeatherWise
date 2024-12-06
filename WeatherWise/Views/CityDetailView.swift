//
//  CityDetailView.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 04/12/2024.
//

import MapKit // importing the mapkit
import SwiftUI

struct CityDetailView: View {
    var city: City
    @State private var weatherDetails: WeatherResponse?
    @State private var forecast: [ForecastItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            MapView(cityName: city.name)
                .ignoresSafeArea()

            if let weatherDetails = weatherDetails {
                VStack {
                    // this the top Section
                    TopSection(weatherDetails: weatherDetails)

                    Spacer()

                    // this the bottom Section
                    BottomSection(weatherDetails: weatherDetails, forecast: forecast)
                        .padding()
                }
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
                        fetchForecast(lat: details.coord.lat, lon: details.coord.lon)
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }

    private func fetchForecast(lat: Double, lon: Double) {
        Task {
            await WeatherService().fetchForecast(lat: lat, lon: lon) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let forecastItems):
                        forecast = forecastItems
                    case .failure(let error):
                        print("Error fetching forecast: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

// this is the Top Section
struct TopSection: View {
    var weatherDetails: WeatherResponse

    var body: some View {
        VStack {
            Text(weatherDetails.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("\(Int(weatherDetails.main.temp))°C")
                .font(.system(size: 60))
                .fontWeight(.light)
                .foregroundColor(.white)
        }
        .padding()
    }
}

// here extracted bottom section to simplify and avoid compiler issues
struct BottomSection: View {
    var weatherDetails: WeatherResponse
    var forecast: [ForecastItem]

    var body: some View {
        VStack(spacing: 16) {
            // First Card: Wind and Humidity
            HStack(spacing: 16) {
                WeatherDetailView(icon: "wind", label: "Wind", value: "\(weatherDetails.wind.speed) m/s")
                WeatherDetailView(icon: "humidity", label: "Humidity", value: "\(weatherDetails.main.humidity)%")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.6))
            )

            // Second Card: Forecast
            VStack(alignment: .leading, spacing: 8) {
                Text("Forecast")
                    .font(.headline)
                    .foregroundColor(.white)

                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 16) {
                        ForEach(forecast, id: \.id) { item in
                            VStack {
                                Text(item.time)
                                    .font(.subheadline)
                                    .foregroundColor(.white)

                                Image(systemName: mapWeatherIcon(item.icon))
                                    .foregroundColor(.white)

                                Text("\(Int(item.temp))°C")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.4))
                            )
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.6))
            )
        }
    }
}

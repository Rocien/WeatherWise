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

    // this function to calculate color based on temperature
    private func temperatureColor(for temperature: Double) -> Color {
        switch temperature {
        case ..<0:
            return Color.blue
        case 0..<15:
            return Color.cyan
        case 15..<25:
            return Color.green
        case 25..<35:
            return Color.orange
        default:
            return Color.red
        }
    }

    var body: some View {
        ZStack {
            // Map background
            MapView(cityName: city.name)
                .ignoresSafeArea()

            // here added gradient overlay
            if let weatherDetails = weatherDetails {
                LinearGradient(
                    gradient: Gradient(colors: [
                        temperatureColor(for: weatherDetails.main.temp).opacity(0.9), // Bottom intense color
                        temperatureColor(for: weatherDetails.main.temp).opacity(0.2) // Top transparent color
                    ]),
                    startPoint: .bottom, // starts at the bottom
                    endPoint: .top // fades towards the top
                )
                .ignoresSafeArea()
            }

            // this the main content
            if let weatherDetails = weatherDetails {
                VStack {
                    // Top Section: City Name and Temperature
                    TopSection(weatherDetails: weatherDetails)

                    Spacer()

                    // Bottom Section: Wind, Humidity, and Forecast
                    BottomSection(weatherDetails: weatherDetails, forecast: forecast)
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

    // this function fetch the city weather
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

    // this function to fetch only the forecast data
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

// this is the Top Section struck
struct TopSection: View {
    var weatherDetails: WeatherResponse
    @State private var isCelsius: Bool = true

    // this function convert celsius to Fahrenheit
    private var displayedTemperature: String {
        if isCelsius {
            return "\(Int(weatherDetails.main.temp))°C"
        } else {
            let fahrenheit = (weatherDetails.main.temp) * 9 / 5 + 32
            return "\(Int(fahrenheit))°F"
        }
    }

    // the City and temp view here
    var body: some View {
        VStack {
            Text(weatherDetails.name)
                .font(.system(size: 50))
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(displayedTemperature)
                .font(.system(size: 80))
                .fontWeight(.light)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .onTapGesture {
                    withAnimation {
                        isCelsius.toggle()
                    }
                }
            Text(getCurrentLocalDateTime(for: weatherDetails.timezone))
                .font(.system(size: 15))
                .fontWeight(.medium)
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
            // First Card Wind and Humidity
            HStack(spacing: 16) {
                WeatherDetailView(icon: "wind", label: "Wind", value: "\(weatherDetails.wind.speed) m/s")
                WeatherDetailView(icon: "humidity", label: "Humidity", value: "\(weatherDetails.main.humidity)%")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.6))
            )

            // second Card Forecast
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

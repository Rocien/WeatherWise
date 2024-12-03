//
//  CityListView.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

import SwiftUI

// this struct to create the city list view
struct CityListView: View {
    @State private var cities: [City] = []
    @State private var isLoading = false
    let weatherService = WeatherService()

    var body: some View {
        // creating a navigation view to list cities
        NavigationView {
            List {
                if isLoading {
                    ProgressView("Fetching weather data...")
                } else {
                    ForEach(cities) { city in
                        HStack {
                            Image(systemName: city.icon)
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text(city.name)
                                    .font(.headline)
                                Text(city.weatherDescription)
                                    .font(.subheadline)
                                Text(city.localTime)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text(city.temperature)
                                .font(.title)
                                .bold()
                        }
                        .padding(.vertical, 8)
                    }
                    .onDelete(perform: deleteCity)
                }
            }
            .navigationTitle("City List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addCity) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                loadInitialCities()
            }
        }
    }

    private func deleteCity(at offsets: IndexSet) {
        cities.remove(atOffsets: offsets)
    }

    // here adding a city dynamically like by e.g., prompt the user for input
    private func addCity() {
        let newCity = "Paris" // for now, leaving Paris as a placeholder
        fetchWeather(for: newCity)
    }

    private func loadInitialCities() {
        let initialCities = ["London", "New York", "Tokyo"]
        for city in initialCities {
            fetchWeather(for: city)
        }
    }

    private func fetchWeather(for city: String) {
        isLoading = true
        Task {
            await weatherService.fetchWeather(for: city) { result in
                DispatchQueue.main.async {
                    isLoading = false
                    switch result {
                    case .success(let weather):
                        let cityData = City(
                            name: weather.name,
                            temperature: "\(Int(weather.main.temp))°C",
                            weatherDescription: weather.weather.first?.description.capitalized ?? "Unknown",
                            icon: mapWeatherIcon(weather.weather.first?.icon ?? "questionmark"),
                            localTime: getCurrentLocalTime(for: weather.timezone)
                        )
                        cities.append(cityData)
                    case .failure(let error):
                        print("Error fetching weather for \(city): \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    private func getCurrentLocalTime(for timezoneOffset: Int) -> String {
        let date = Date()
        let localTime = date.addingTimeInterval(TimeInterval(timezoneOffset))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: localTime)
    }
}

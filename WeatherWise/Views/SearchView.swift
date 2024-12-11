//
//  SearchView.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

import SwiftUI

struct SearchView: View {
    @Binding var cities: [City] // this binding to directly modify the cities array in CityListView
    @State private var searchText = ""
    @State private var allCities: [String] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @Environment(\.dismiss) private var dismiss // this is for dismissing the view

    // created variale to carry my hardcoded popular cities which will be used inside the popular city section down below
    private let popularCities: [String] = ["Paris", "Ottawa", "Montreal", "Los Angeles"]

    var body: some View {
        VStack(spacing: 20) {
            // Header Section
            HStack {
                Button(action: {
                    dismiss() // dismiss the SearchView
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.title2)
                }

                Spacer()

                Text("Search for City")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                Spacer()
            }
            .padding()

            // the search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("", text: $searchText, prompt: Text("Search for a city...")
                    .foregroundColor(.gray))
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.black)
                    .padding(.leading, 5)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 30).fill(Color.white))

            // popular Cities Section
            if !popularCities.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Popular Cities")
                        .font(.headline)
                        .foregroundColor(.white)

                    HStack(spacing: 10) {
                        ForEach(popularCities, id: \.self) { city in
                            Button(action: {
                                addCity(city)
                            }) {
                                Text(city)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 10)
                                    .background(Capsule().fill(Color.white))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }

            // City List Section
            if isLoading {
                ProgressView("Loading cities...")
                    .foregroundColor(.white)
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                List {
                    ForEach(allCities.filter { $0.localizedCaseInsensitiveContains(searchText) || searchText.isEmpty }, id: \.self) { city in
                        HStack {
                            Text(city)
                                .foregroundColor(.white)
                            Spacer()
                            Button(action: {
                                addCity(city)
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .listRowSeparatorTint(.white)
                    .listRowBackground(Color.clear) // change Row Color
                    .foregroundColor(Color.white)
                }
                .listRowBackground(Color.black.opacity(0.1))
                .listStyle(PlainListStyle())
            }
        }
        .padding(.horizontal)
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        .scrollContentBackground(.hidden)
        .onAppear {
            fetchCities()
        }
    }

    private func fetchCities() {
        isLoading = true
        WeatherService().fetchCityNames { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let cityNames):
                    self.allCities = cityNames
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func addCity(_ cityName: String) {
        let weatherService = WeatherService() // this creating an instance of WeatherService

        // Fetch weather details for the selected city
        Task {
            await weatherService.fetchWeather(for: cityName) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let weather):
                        // Create a new city object with fetched data
                        let newCity = City(
                            name: weather.name,
                            temperature: "\(Int(weather.main.temp))°C",
                            weatherDescription: weather.weather.first?.description.capitalized ?? "Unknown",
                            icon: mapWeatherIcon(weather.weather.first?.icon ?? "questionmark"),
                            localTime: getCurrentLocalTime(for: weather.timezone),
                            coord: CityCoord(lat: weather.coord.lat, lon: weather.coord.lon)
                        )
                        cities.append(newCity) // adding the new city to the list
                        saveCityList() // here saving the updated city list
                    case .failure(let error):
                        print("Error fetching weather for \(cityName): \(error.localizedDescription)")
                    }
                }
            }
        }
        dismiss() // used dismiss the envirnment created on top, this will dismiss the SearchView
    }

    private func saveCityList() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cities) {
            UserDefaults.standard.set(encoded, forKey: "CityList")
        }
    }
}

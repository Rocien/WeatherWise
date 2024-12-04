//
//  CityListView.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

import SwiftUI

// this struct to create the city list view
struct CityListView: View {
    // here where adding all the state variable creating
    @State private var cities: [City] = []
    @State private var isLoading = false
    @State private var isShowingSearch = false
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
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
                    .onDelete(perform: deleteCity) // called the deleteCity function
                }
            }
            .navigationTitle("City List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingSearch = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }

            // the sheet that pop on the city screen to display the input field to search for cities
            .sheet(isPresented: $isShowingSearch) {
                SearchView { cityName in
                    fetchWeather(for: cityName) // this add the searched city
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                loadInitialCities()
            }
        }
    }

    // swipe to the left to delete the city on the screen
    private func deleteCity(at offsets: IndexSet) {
        cities.remove(atOffsets: offsets)
    }

    // here i am just calling cities that will show initially when the app is launched
    private func loadInitialCities() {
        let initialCities = ["Ottawa", "Toronto", "Tokyo"]
        for city in initialCities {
            fetchWeather(for: city)
        }
    }

    // here the fetching the data from the weatherService to display
    private func fetchWeather(for city: String) {
        isLoading = true
        Task {
            await weatherService.fetchWeather(for: city) { result in
                DispatchQueue.main.async {
                    isLoading = false
                    // statement to display cities with weather or alert message
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
                        alertMessage = "Could not fetch weather for \(city). Please try again."
                        showAlert = true
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

//
//  CityListView.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

import SwiftUI

// import WeatherUtils

// this struct to create the city list view
struct CityListView: View {
    // here where adding all the state variable creating
    @State private var cities: [City] = []
    @State private var isLoading = false
    @State private var isShowingSearch = false
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    let weatherService = WeatherService()
    @State private var refreshInterval: Int = UserDefaults.standard.integer(forKey: "RefreshInterval")

    // this function for the icon color changes according to the wheather fetched
    func weatherIconColor(for weatherCondition: String) -> Color {
        switch weatherCondition.lowercased() {
        case "clear sky", "sunny":
            return .yellow
        case "clouds", "overcast clouds", "broken clouds":
            return .white
        case "rain", "drizzle":
            return .blue
        case "snow":
            return .white
        case "mist", "fog":
            return .purple
        default:
            return .blue
        }
    }

    var body: some View {
        // creating a navigation view to list cities
        NavigationView {
            List {
                if isLoading {
                    ProgressView("Fetching weather data...")
                } else {
                    ForEach(cities) { city in
                        NavigationLink(destination: CityDetailView(city: city)) {
                            HStack(alignment: .top) {
                                // city name and temperature on the left
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(city.temperature)
                                        .font(.largeTitle)
                                        .bold()
                                        .foregroundColor(Color.white)
                                    Text(city.name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(city.localTime)
                                        .font(.footnote)
                                        .foregroundColor(Color.white.opacity(0.6))
                                }
                                Spacer()

                                // icon and description aligned vertically on the right
                                VStack(alignment: .center, spacing: 8) {
                                    Image(systemName: city.icon)
                                        .font(.largeTitle)
                                        .foregroundColor(weatherIconColor(for: city.weatherDescription))
                                    Text(city.weatherDescription)
                                        .font(.subheadline)
                                        .foregroundColor(Color.white)
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 50))
                                }
                                .frame(width: 100)
                            }
                            .padding(.vertical, 10)
                        }
                        .listRowBackground(Color.black.opacity(0.1))
                    }
                    .onMove(perform: moveCity) // here enable reordering
                    .onDelete(perform: deleteCity) // called the deleteCity function
                    .listRowSeparatorTint(.white)
                    .listRowBackground(Color.clear) // change Row Color
                    .foregroundColor(Color.white)
                }
            }

            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
            .scrollContentBackground(.hidden)
            .navigationTitle("City List")
//            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton() // Ensures the Edit button remains
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingSearch.toggle() // Toggles the SearchView
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            .sheet(isPresented: $isShowingSearch) { // presenting the SearchView as a sheet
                SearchView(cities: $cities) // here i am passing cities as a binding to SearchView (created binding inside SearchView where states ares)
            }
            // the alert to display message if fetching weather data fail
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"), // is it shows in the IOS, this is the title of error
                    message: Text(alertMessage), // and this is the detailed message of alert
                    dismissButton: .default(Text("OK")) // with the OK button to dismiss
                )
            }
        }
        .onAppear {
            loadCityList() // here just loading the city list when the view appears
        }
    }

    // this function is for the user to move the city or rearrange
    private func moveCity(from source: IndexSet, to destination: Int) {
        withAnimation {
            cities.move(fromOffsets: source, toOffset: destination)
        }
        saveCityList() // called saveCityList to save updated order to UserDefaults
    }

    // this function to start refreshing the data based on the interval
    private func startAutoRefresh() {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(refreshInterval * 60), repeats: true) { _ in
            refreshWeatherData()
        }
    }

    // function to refresh weather data
    private func refreshWeatherData() {
        for city in cities {
            fetchWeather(for: city.name)
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
                        print("Timezone Offset from API: \(weather.timezone)")
                        let cityData = City(
                            name: weather.name,
                            temperature: "\(Int(weather.main.temp))°C",
                            weatherDescription: weather.weather.first?.description.capitalized ?? "Unknown",
                            icon: mapWeatherIcon(weather.weather.first?.icon ?? "questionmark"),
                            localTime: getCurrentLocalTime(for: weather.timezone),
                            coord: CityCoord(lat: weather.coord.lat, lon: weather.coord.lon)
                        )
                        withAnimation {
                            cities.append(cityData) // added city with animation
                        }
                        saveCityList() // save after adding a city
                    case .failure(let error):
                        alertMessage = "Could not fetch weather for \(city). Please try again."
                        showAlert = true
                        print("Error fetching weather for \(city): \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    // swipe to the left to delete the city on the screen
    private func deleteCity(at offsets: IndexSet) {
        withAnimation {
            cities.remove(atOffsets: offsets)
        }
        saveCityList() // Save after deleting a city
    }

    // here i am just calling cities that will show initially when the app is launched
    private func loadInitialCities() {
        let initialCities = ["Ottawa", "Montreal", "Toronto", "Calgary", "Edmonton"]
        for city in initialCities {
            fetchWeather(for: city)
        }
    }

    // save the city list to UserDefaults
    private func saveCityList() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cities) {
            UserDefaults.standard.set(encoded, forKey: "CityList")
        }
    }

    // load the city list from UserDefaults
    private func loadCityList() {
        if let savedData = UserDefaults.standard.data(forKey: "CityList") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([City].self, from: savedData) {
                cities = decoded
            }
        } else {
            // load initial cities only if no saved data exists on the page
            loadInitialCities()
        }
    }
}

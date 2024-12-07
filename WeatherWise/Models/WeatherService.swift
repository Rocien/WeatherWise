//
//  WeatherService.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

import Foundation // the foundation import the essential data to use in the project such (date, time, handling basic app data) added it here as dealing with json

// mapping the json structure from openWeather API
struct WeatherResponse: Codable {
    // the WeatherResponse represents the overall JSON structure returned by the API.
    let coord: Coord
    let weather: [WeatherDetail]
    let main: Main
    let wind: Wind
    let name: String
    let timezone: Int

    // the below are just nested structures represent subparts of the JSON
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }

    struct WeatherDetail: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }

    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }
}

// this is the forecast response structure
struct ForecastResponse: Codable {
    let list: [ForecastDetail]

    struct ForecastDetail: Codable {
        let dt: Int
        let main: Main
        let weather: [Weather]

        struct Main: Codable {
            let temp: Double
        }

        struct Weather: Codable {
            let icon: String
        }
    }
}

// this is the forecast item for the
struct ForecastItem: Identifiable {
    let id = UUID() // here the unique identifier for the item
    let time: String
    let temp: Double
    let icon: String
}

// this class using open weather API with my own key to dynamically fetch data for cities.
class WeatherService {
    let apiKey = "abe605e9339d49f8a6453cd5c439ff84" // my api key with openWeather

    // this fetching call for the CityListView in the home page
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) async {
        // this the url for API, set units to metric for celsius
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        // this block create the url object
        guard let url = URL(string: urlString) else { // this handle error, if the string is invalid
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return // exiting the function early, make sure no code runs when the url is invalid
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print("Raw API Response: \(String(data: data, encoding: .utf8) ?? "No Data")") // Debugging
            let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            completion(.success(decodedResponse))
        } catch let decodingError {
            print("Decoding Error: \(decodingError.localizedDescription)")
            completion(.failure(decodingError))
        }
    }

    // this fetch call for the details view
    func fetchForecast(lat: Double, lon: Double, completion: @escaping (Result<[ForecastItem], Error>) -> Void) async {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        // here now making the API call with do-catch method
        do {
            let (data, _) = try await URLSession.shared.data(from: url) // do an async network call from the url
            let decodedResponse = try JSONDecoder().decode(ForecastResponse.self, from: data) // decode the raw json into ForecastResponse structure i created above
            let forecastItems = decodedResponse.list.map { detail in
                ForecastItem( // here creating a ForecastItem object with formatted time, temperature
                    time: formatTimestamp(detail.dt),
                    temp: detail.main.temp,
                    icon: detail.weather.first?.icon ?? "questionmark" // create icon or questionmark if icon missing
                )
            }
            completion(.success(forecastItems)) // passing the list of ForecastItem objects to the completion handler as a success result.

        } catch {
            completion(.failure(error)) // or if the above fail catch the error and handle failure
        }
    }

    // this block of function for the time
    private func formatTimestamp(_ timestamp: Int) -> String {
        // converting a UNIX timestamp to a human-readable time string (HH:mm format).
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

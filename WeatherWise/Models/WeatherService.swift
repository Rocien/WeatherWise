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

// JSON Model for City Population API Response
struct CityPopulationResponse: Decodable {
    let error: Bool
    let msg: String
    let data: [CityData]

    struct CityData: Decodable {
        let city: String
        let country: String
    }
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
        // here now making the API call with do-catch method
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print("Raw API Response: \(String(data: data, encoding: .utf8) ?? "No Data")") // just debugging
            let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            completion(.success(decodedResponse))
        } catch let decodingError {
            print("Decoding Error: \(decodingError.localizedDescription)")
            completion(.failure(decodingError))
        }
    }

    // this fetch call for the details view, only for the forecast
    func fetchForecast(lat: Double, lon: Double, completion: @escaping (Result<[ForecastItem], Error>) -> Void) async { // changed the API endpoint to fetch the forecast details
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return // exiting the function early, make sure no code runs when the url is invalid
        }
        // here now making the API call with do-catch method just as the above function
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

    // fetch city names from the API
    func fetchCityNames(completion: @escaping (Result<[String], Error>) -> Void) {
        let urlString = "https://countriesnow.space/api/v0.1/countries/population/cities"

        // Validate URL
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        // Configure URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Using GET method as we’re retrieving data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Start the network request
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error)) // Handle network error
                return
            }

            // Ensure valid response data
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "No Data"])))
                return
            }

            do {
                // Decode JSON response
                let decodedResponse = try JSONDecoder().decode(CityPopulationResponse.self, from: data)
                let cityNames = decodedResponse.data.map { $0.city }
                completion(.success(cityNames))
            } catch {
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to parse city data."])))
            }
        }.resume()
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

//
//  WeatherService.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

import Foundation // this import the essential data to use in the project such (date, time, handling basic app data)

// mapping the json structure
struct WeatherResponse: Decodable {
    let name: String // City name
    let main: Main
    let weather: [WeatherDetail]
    let timezone: Int
}

struct Main: Decodable {
    let temp: Double // Current temperature
}

struct WeatherDetail: Decodable {
    let description: String
    let icon: String
}

// here this class using open weather API with my own key to dynamically fetch data for cities instead of hard cording.
class WeatherService {
    let apiKey = "abe605e9339d49f8a6453cd5c439ff84"

    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) async {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw Response: \(rawResponse)")
            }

            let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            completion(.success(decodedResponse))
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
}

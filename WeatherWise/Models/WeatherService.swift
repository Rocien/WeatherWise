//
//  WeatherService.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

import Foundation // this import the essential data to use in the project such (date, time, handling basic app data)

// mapping the json structure
struct WeatherResponse: Decodable {
    let name: String
    let main: Main
    let weather: [WeatherDetail]
    let wind: Wind
    let timezone: Int
    let coord: Coord
}

struct Main: Decodable {
    let temp: Double
    let humidity: Int
}

struct WeatherDetail: Decodable {
    let description: String
    let icon: String
}

struct Wind: Decodable {
    let speed: Double
}

struct Coord: Decodable {
    let lat: Double
    let lon: Double
}

// here this class using open weather API with my own key to dynamically fetch data for cities instead of hard cording.
class WeatherService {
    let apiKey = "abe605e9339d49f8a6453cd5c439ff84"

    // this fetching call for the landing page which each the CityListView
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

    // this fetch call for the details view
    func fetchWeatherDetails(lat: Double, lon: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void) async {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            completion(.success(decodedResponse))
        } catch {
            completion(.failure(error))
        }
    }
}

//
//  WeatherService.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

import Foundation // this import the essential data to use in the project such (date, time, handling basic app data)

// mapping the json structure
struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [WeatherDetail]
    let main: Main
    let wind: Wind
    let name: String
    let timezone: Int

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
            print("Raw API Response: \(String(data: data, encoding: .utf8) ?? "No Data")") // Debugging
            let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            completion(.success(decodedResponse))
        } catch let decodingError {
            print("Decoding Error: \(decodingError.localizedDescription)")
            completion(.failure(decodingError))
        }
    }

    // this fetch call for the details view
    func fetchWeatherDetails(lat: Double, lon: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void) async {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,hourly,daily,alerts&appid=\(apiKey)&units=metric"
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

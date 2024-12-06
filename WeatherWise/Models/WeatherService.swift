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

struct ForecastItem: Identifiable {
    let id = UUID()
    let time: String
    let temp: Double
    let icon: String
}

// this class using open weather API with my own key to dynamically fetch data for cities instead of hardcording.
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
    func fetchForecast(lat: Double, lon: Double, completion: @escaping (Result<[ForecastItem], Error>) -> Void) async {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
            let forecastItems = decodedResponse.list.map { detail in
                ForecastItem(
                    time: formatTimestamp(detail.dt),
                    temp: detail.main.temp,
                    icon: detail.weather.first?.icon ?? "questionmark"
                )
            }
            completion(.success(forecastItems))
        } catch {
            completion(.failure(error))
        }
    }

    private func formatTimestamp(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

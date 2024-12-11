//
//  WeatherUtils.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 10/12/2024.
//

import Foundation

// maps OpenWeather API's weather icon codes to system image names
func mapWeatherIcon(_ iconCode: String) -> String { // this function takes a string code and change it to a string icon name
    switch iconCode { // this matches the iconCode (provided by OpenWeather API against predefined cases.
    case "01d": return "sun.max.fill" // Clear sky (day)
    case "01n": return "moon.stars.fill" // Clear sky (night)
    case "02d": return "cloud.sun.fill" // Few clouds (day)
    case "02n": return "cloud.moon.fill" // Few clouds (night)
    case "03d", "03n": return "cloud.fill" // Scattered clouds
    case "04d", "04n": return "smoke.fill" // Broken clouds
    case "09d", "09n": return "cloud.drizzle.fill" // Shower rain
    case "10d": return "cloud.sun.rain.fill" // Rain (day)
    case "10n": return "cloud.moon.rain.fill" // Rain (night)
    case "11d", "11n": return "cloud.bolt.fill" // Thunderstorm
    case "13d", "13n": return "snowflake" // Snow
    case "50d", "50n": return "cloud.fog.fill" // Mist
    default: return "questionmark.circle.fill" // Fallback for unknown icons
    }
}

// Calculates the local time for a city using the timezone offset
func getCurrentLocalTime(for timezoneOffset: Int) -> String {
    let utcDate = Date()
    let localDate = utcDate.addingTimeInterval(TimeInterval(timezoneOffset))

    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
    dateFormatter.dateFormat = "hh:mm a"

    return dateFormatter.string(from: localDate)
}

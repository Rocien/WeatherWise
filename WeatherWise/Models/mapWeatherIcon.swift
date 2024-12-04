//
//  mapWeatherIcon.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

import Foundation

// created icons here to be reusable
func mapWeatherIcon(_ iconCode: String) -> String {
    switch iconCode {
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

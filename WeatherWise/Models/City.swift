//
//  City.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

// in this struct iam creating variables that will use later in the project, defining the data for each city
import Foundation

 struct City: Identifiable, Codable {
    let id: UUID
    var name: String
    var temperature: String
    var weatherDescription: String
    var icon: String
    var localTime: String
    var coord: CityCoord

    init(
        id: UUID = UUID(),
        name: String,
        temperature: String,
        weatherDescription: String,
        icon: String,
        localTime: String,
        coord: CityCoord
    ) {
        self.id = id
        self.name = name
        self.temperature = temperature
        self.weatherDescription = weatherDescription
        self.icon = icon
        self.localTime = localTime
        self.coord = coord
    }
 }

 struct CityCoord: Codable {
    let lat: Double
    let lon: Double
 }

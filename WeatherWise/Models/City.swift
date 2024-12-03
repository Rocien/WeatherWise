//
//  City.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

import Foundation // here to help accessing the essential data like (date and time etc...)

// in this struct iam creating variables that will use later in the project, defining the data for each city
struct City: Identifiable {
    let id = UUID() // this will be the unique identifier for each city
    var name: String
    var temperature: String
    var weatherDescription: String
    var icon: String
    var localTime: String
}

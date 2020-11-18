//
//  WeatherLocation.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import Foundation

struct WeatherLocation: Codable {
    let id: Int
    let name: String
    let timezone: Int
    let coord: Coord
    let weather: [Weather]
    let temperature: Temperature
    let wind: Wind
    let country: Country
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case timezone
        case coord
        case weather
        case temperature = "main"
        case wind
        case country = "sys"
    }
}

struct Coord: Codable {
    let lon: Decimal
    let lat: Decimal
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temperature: Codable {
    let temp: Decimal
    let feelsLike: Decimal
    let tempMin: Decimal
    let tempMax: Decimal
    let humidity: Decimal
    let pressure: Decimal
    
    private enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case feelsLike = "feels_like"
        case pressure = "pressure"
        case humidity = "humidity"
    }
}

struct Wind: Codable {
    let speed: Decimal
    let deg: Int
}

struct Country: Codable {
    let type: Int
    let countryCode: String
    let sunrise: Int
    let sunset: Int
}

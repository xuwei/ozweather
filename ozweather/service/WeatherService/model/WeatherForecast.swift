//
//  WeatherLocation.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import Foundation

struct WeatherForecast: Codable {
    let id: Int
    let name: String
    let timezone: Double
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
    let longitude: Double
    let latitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temperature: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Double
    let pressure: Double
    
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
    let speed: Double
    let deg: Int
}

struct Country: Codable {
    let countryCode: String?
    let sunrise: Double
    let sunset: Double
    
    private enum CodingKeys: String, CodingKey {
        case countryCode = "country"
        case sunrise
        case sunset
    }
}

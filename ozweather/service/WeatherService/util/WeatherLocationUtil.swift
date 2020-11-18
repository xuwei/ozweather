//
//  WeatherLocationUtil.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import Foundation

class WeatherLocationUtil {
    
    func mockWeatherLocation()-> WeatherLocation {
        return atlanta()
    }
    
    func mockRecent()-> [WeatherLocation] {
        return [atlanta(), sydney()]
    }
    
    private func atlanta()-> WeatherLocation {
        let coord = Coord(lon: -84.39, lat: 33.75)
        let weather = Weather(id: 1, main: "Clear", description: "clear sky", icon: "01d")
        let temperature = Temperature(temp: 289.81, feelsLike: 285.66, tempMin: 288.15, tempMax: 291.15, humidity: 17, pressure: 1031)
        let wind = Wind(speed: 1.73, deg: 88)
        let country = Country(type: 1, countryCode: "US", sunrise: 1605701583, sunset: 1605738778)
        
        let weatherLocation = WeatherLocation(id: 1, name: "Atlanta", timezone: -18000, coord: coord, weather: [weather], temperature: temperature, wind: wind, country: country)
        
        return weatherLocation
    }
    
    private func sydney()->WeatherLocation {
        let coord = Coord(lon: 151.21, lat: -33.87)
        let weather = Weather(id: 2, main: "Rain", description: "light rain", icon: "10d")
        let temperature = Temperature(temp: 294.68, feelsLike: 293.92, tempMin: 293.71, tempMax: 296.15, humidity: 64, pressure: 1023)
        let wind = Wind(speed: 3.1, deg: 40)
        let country = Country(type: 2, countryCode: "AU", sunrise: 1605724885, sunset: 1605775198)
        
        let weatherLocation = WeatherLocation(id: 2, name: "Sydney", timezone: 39600, coord: coord, weather: [weather], temperature: temperature, wind: wind, country: country)
        
        return weatherLocation
    }
}

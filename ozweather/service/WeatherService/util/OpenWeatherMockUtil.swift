//
//  WeatherLocationUtil.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import Foundation

class OpenWeatherMockUtil {
    
    func mockWeatherLocation()-> WeatherForecast {
        return atlanta()
    }
    
    func mockRecent()-> [WeatherForecast] {
        return [atlanta(), sydney()]
    }
    
    private func atlanta()-> WeatherForecast {
        let coord = Coord(longitude: -84.39, latitude: 33.75)
        let weather = Weather(id: 1, main: "Clear", description: "clear sky", icon: "01d")
        let temperature = Temperature(temp: 289.81, feelsLike: 285.66, tempMin: 288.15, tempMax: 291.15, humidity: 17, pressure: 1031)
        let wind = Wind(speed: 1.73, deg: 88)
        let country = Country(countryCode: "US", sunrise: 1605701583, sunset: 1605738778)
        
        let weatherForecast = WeatherForecast(id: 1, name: "Atlanta", timezone: -18000, coord: coord, weather: [weather], temperature: temperature, wind: wind, country: country)
        return weatherForecast
    }
    
    private func sydney()->WeatherForecast {
        let coord = Coord(longitude: 151.21, latitude: -33.87)
        let weather = Weather(id: 2, main: "Rain", description: "light rain", icon: "10d")
        let temperature = Temperature(temp: 294.68, feelsLike: 293.92, tempMin: 293.71, tempMax: 296.15, humidity: 64, pressure: 1023)
        let wind = Wind(speed: 3.1, deg: 40)
        let country = Country(countryCode: "AU", sunrise: 1605724885, sunset: 1605775198)
        
        let weatherForecast = WeatherForecast(id: 2, name: "Sydney", timezone: 39600, coord: coord, weather: [weather], temperature: temperature, wind: wind, country: country)
        return weatherForecast
    }
}

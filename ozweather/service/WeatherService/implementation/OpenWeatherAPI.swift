//
//  OpenWeatherService.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import Foundation

class OpenWeatherAPI: WeatherServiceProtocol {

    static let shared = OpenWeatherAPI()
    let apiKey = "d4ceceb6cea308f9458e02a7ddb693cf"
    let baseUrl = "http://api.openweathermap.org/data/2.5/weather"
    
//    ?appid=d4ceceb6cea308f9458e02a7ddb693cf&q=sydney"
    
    private init() {
        
    }
    
    func searchBy(query: String, completionHandler: @escaping (Result<WeatherLocation, Error>)-> Void) {
        let location = WeatherLocationUtil().mockWeatherLocation()
        completionHandler(.success(location))
    }

    func updateRecent(locations: [WeatherLocation], completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    
}

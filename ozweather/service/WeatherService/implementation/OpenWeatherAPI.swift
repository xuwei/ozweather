//
//  OpenWeatherService.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import Foundation
import CoreLocation

class OpenWeatherAPI: WeatherServiceProtocol {

    static let shared = OpenWeatherAPI()
    let apiKey = "d4ceceb6cea308f9458e02a7ddb693cf"
    let baseUrl = "http://api.openweathermap.org/data/2.5/weather"
    
//    ?appid=d4ceceb6cea308f9458e02a7ddb693cf&q=sydney"
    
    private init() {
    }
    
    func searchBy(query: WeatherSearchRequest, completionHandler: @escaping (Result<WeatherLocation, WeatherServiceError>)-> Void) {
        let location = WeatherLocationUtil().mockWeatherLocation()
        completionHandler(.success(location))
    }  
}

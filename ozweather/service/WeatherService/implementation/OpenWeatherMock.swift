//
//  OpenWeatherMock.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import Foundation

class OpenWeatherMock: WeatherServiceProtocol {
    
    static let shared = OpenWeatherMock()
    private init() { }
    
    func searchBy(query: String, completionHandler: @escaping (Result<WeatherLocation, Error>) -> Void) {
        let location = WeatherLocationUtil().mockWeatherLocation()
        completionHandler(.success(location))
    }
    
    func updateRecent(locations: [WeatherLocation], completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
}

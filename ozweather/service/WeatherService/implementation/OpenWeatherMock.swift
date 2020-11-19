//
//  OpenWeatherMock.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import Foundation
import CoreLocation

class OpenWeatherMock: WeatherServiceProtocol {
    
    static let shared = OpenWeatherMock()
    let mockLocation = WeatherLocationUtil().mockWeatherLocation()
    let validZipCode = "30303"
    
    private init() { }
    
    func searchBy(query: WeatherSearchRequest, completionHandler: @escaping (Result<WeatherForecast, WeatherServiceError>) -> Void) {
        switch query.type {
        case .city:
            if mockLocation.name == query.city {
                completionHandler(.success(mockLocation))
            } else {
                completionHandler(.failure(WeatherServiceError.invalidParam))
            }
            return
        case .zipCode:
            if validZipCode == query.zip {
                completionHandler(.success(mockLocation))
            } else {
                completionHandler(.failure(WeatherServiceError.invalidParam))
            }
            return
        case .gpsCoord:
            completionHandler(.success((mockLocation)))
            return
        }
    }
}

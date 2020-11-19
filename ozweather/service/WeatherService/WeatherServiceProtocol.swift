//
//  WeatherServiceProtocol.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import Foundation
import CoreLocation

protocol WeatherServiceProtocol {
    
    func searchBy(query: WeatherSearchRequest, completionHandler: @escaping (Result<WeatherForecast, WeatherServiceError>)-> Void)
}

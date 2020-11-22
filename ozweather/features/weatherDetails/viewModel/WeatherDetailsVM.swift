//
//  WeatherDetailsVM.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import UIKit

class WeatherDetailsVM {
    
    let title: String
    
    private var weatheService: WeatherServiceProtocol = OpenWeatherAPI.shared
    private var weatherForecast: WeatherForecast?
    private let weatherSearchRequest: WeatherSearchRequest
    
    init(title: String, weatheService: WeatherServiceProtocol, request: WeatherSearchRequest) {
        self.title = title
        self.weatheService = weatheService
        self.weatherSearchRequest = request
    }
    
    // for dependency injection
    convenience init(title: String, weatheService: WeatherServiceProtocol, request: WeatherSearchRequest, forecast: WeatherForecast) {
        self.init(title: title, weatheService: weatheService, request: request)
        self.weatherForecast = forecast
    }
    
    func refreshForecast(_ completionHandler: @escaping (Result<WeatherForecast, WeatherServiceError>)->Void) {
        completionHandler(.success(OpenWeatherMockUtil().mockWeatherForecast()))
    }
}

//
//  WeatherDetailsVM.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import UIKit

class WeatherDetailsVM {
    
    init(weatheService: WeatherServiceProtocol, request: WeatherSearchRequest) {
        self.weatheService = weatheService
        self.weatherSearchRequest = request
    }
    
    // for dependency injection
    convenience init(weatheService: WeatherServiceProtocol, request: WeatherSearchRequest, forecast: WeatherForecast) {
        self.init(weatheService: weatheService, request: request)
        self.weatherForecast = forecast
    }
    
    private var weatheService: WeatherServiceProtocol = OpenWeatherAPI.shared
    private var weatherForecast: WeatherForecast?
    private let weatherSearchRequest: WeatherSearchRequest
    
    let title = ScreenName.forecast.rawValue
    
    
    func refreshForecast(_ completionHandler: @escaping (Result<WeatherForecast, WeatherServiceError>)->Void) {
        completionHandler(.success(OpenWeatherMockUtil().mockWeatherForecast()))
    }
}

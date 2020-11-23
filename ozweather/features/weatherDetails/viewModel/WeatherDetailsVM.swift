//
//  WeatherDetailsVM.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import UIKit

class WeatherDetailsVM {
    
    let title: String
    var cellVM: WeatherForecastCellVM?
    private var weatheService: WeatherServiceProtocol = OpenWeatherAPI.shared
    private let weatherSearchRequest: WeatherSearchRequest
    
    init(title: String, weatheService: WeatherServiceProtocol, request: WeatherSearchRequest) {
        self.title = title
        self.weatheService = weatheService
        self.weatherSearchRequest = request
    }
    
    // for dependency injection
    convenience init(title: String, weatheService: WeatherServiceProtocol, request: WeatherSearchRequest, forecast: WeatherForecast) {
        self.init(title: title, weatheService: weatheService, request: request)
        cellVM = toWeatherForecastCellVM(with: forecast)
    }
    
    private func toWeatherForecastCellVM(with forecast:WeatherForecast)->WeatherForecastCellVM {
        let weatherDescription = forecast.weather.first?.description ?? ""
        return WeatherForecastCellVM(identifier: WeatherForecastCell.identifier, location: forecast.name, coordString: forecast.coord.stringify(), weatherDescription: weatherDescription, iconUrl: "", temperature: forecast.temperature.feelsLike, country: forecast.country.countryCode ?? "")
    }
    
    func refreshForecast(_ completionHandler: @escaping (Result<WeatherForecast, WeatherServiceError>)->Void) {
        self.weatheService.searchBy(query: self.weatherSearchRequest) { [weak self] result in
            guard let self = self else { completionHandler(.failure(.genericError)); return}
            switch result {
            case .success(let forecast):
                self.cellVM = self.toWeatherForecastCellVM(with: forecast)
                completionHandler(.success(forecast))
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }
    
    func forecastLoaded()->Bool {
        return self.cellVM != nil ? true : false
    }
}

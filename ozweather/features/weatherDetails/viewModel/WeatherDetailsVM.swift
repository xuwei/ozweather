//
//  WeatherDetailsVM.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import UIKit
import CoreLocation

class WeatherDetailsVM {
    
    let title: String
    var cellVM: WeatherForecastCellVM?
    private var weatheService: WeatherServiceProtocol = OpenWeatherService.shared
    private var weatherSearchRequest: WeatherSearchRequest
    
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
    
    func updateLocation(_ location: CLLocation) {
        let location2D = location.toCLLocationCoordinate2D()
        self.weatherSearchRequest = WeatherSearchRequest(coord: location2D, type: .gpsCoord)
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
    
    func needLocationService()->Bool {
        return weatherSearchRequest.type == .gpsCoord
    }
    
    private func toWeatherForecastCellVM(with forecast:WeatherForecast)->WeatherForecastCellVM {
        var url = ""
        if let weather: Weather = forecast.weather.first {
            url = OpenWeatherImageUtil().generateIconImageUrl(weather.icon) ?? ""
        }
        
        let weatherDescription = forecast.weather.first?.description ?? ""
        return WeatherForecastCellVM(identifier: WeatherForecastCell.identifier, location: forecast.name, coordString: forecast.coord.stringify(), weatherDescription: weatherDescription, iconUrl: url, temperature: forecast.temperature.feelsLike, country: forecast.country.countryCode ?? "")
    }
    
}

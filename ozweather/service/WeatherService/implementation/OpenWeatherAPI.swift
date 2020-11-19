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
    private let apiKey = "d4ceceb6cea308f9458e02a7ddb693cf"
    private let httpProtocol = "https"
    private let domain = "api.openweathermap.org"
    private let path = "/data/2.5/weather"
    private let units = "metric"
    private let session: URLSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    
    private init() {
    }
    
    func searchBy(query: WeatherSearchRequest, completionHandler: @escaping (Result<WeatherForecast, WeatherServiceError>)-> Void) {
        switch query.type {
        case .city:
            searchByCity(query) { result in
                completionHandler(result)
            }
            break
        case .zipCode:
            searchByZipcode(query) { result in
                completionHandler(result)
            }
            break
        case .gpsCoord:
            searchByGps(query) { result in
                completionHandler(result)
            }
            break
        }
    }
    
    // MARK: helper methods for searchBy
    private func searchByCity(_ query: WeatherSearchRequest, completionHandler: @escaping (Result<WeatherForecast, WeatherServiceError>)-> Void) {
        let urlComponent: URLComponents? = generateCitySearchUrl(query)
        guard let url = urlComponent?.url else { completionHandler(.failure(.invalidParam)); return }
        dataTask = session.dataTask(with: url) { [weak self] data, response, err in
            guard let self = self else { completionHandler(.failure(.genericError)); return }
            defer { self.dataTask = nil }
            
            JsonUtil.shared.printAsJson(data: data)
            self.handleWeatherLocationResponse(data: data, err: err, response: response) { result in
                completionHandler(result)
            }
        }
        dataTask?.resume()
    }
    
    private func searchByZipcode(_ query: WeatherSearchRequest, completionHandler: @escaping (Result<WeatherForecast, WeatherServiceError>)-> Void) {
        let urlComponent: URLComponents? = generateZipcodeSearchUrl(query)
        guard let url = urlComponent?.url else { completionHandler(.failure(.invalidParam)); return }
        dataTask = session.dataTask(with: url) { [weak self] data, response, err in
            guard let self = self else { completionHandler(.failure(.genericError)); return }
            defer { self.dataTask = nil }
            self.handleWeatherLocationResponse(data: data, err: err, response: response) { result in
                completionHandler(result)
            }
        }
        dataTask?.resume()
    }
    
    private func searchByGps(_ query: WeatherSearchRequest, completionHandler: @escaping (Result<WeatherForecast, WeatherServiceError>)-> Void) {
        let urlComponent: URLComponents? = generateCoordSearchUrl(query)
        guard let url = urlComponent?.url else { completionHandler(.failure(.invalidParam)); return }
        dataTask = session.dataTask(with: url) { [weak self] data, response, err in
            guard let self = self else { completionHandler(.failure(.genericError)); return }
            defer { self.dataTask = nil }
            self.handleWeatherLocationResponse(data: data, err: err, response: response) { result in
                completionHandler(result)
            }
        }
        dataTask?.resume()
    }
    
    // helper method for handling WeatherLocation response
    private func handleWeatherLocationResponse(data: Data?, err: Error?, response: URLResponse?, completionHandler: @escaping (Result<WeatherForecast, WeatherServiceError>)->Void) {
        // use generic error to handle backend error
        if err != nil { completionHandler(.failure(.genericError)); return }
        
        guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == HttpStatusSuccess else {
            completionHandler(.failure(.genericError)); return
        }
        
        let resultDecoder = JSONDecoder()
        do {
            let result: WeatherForecast = try resultDecoder.decode(WeatherForecast.self, from: data)
            completionHandler(.success(result))
        } catch let err {
            completionHandler(.failure(.genericError))
        }
    }
  
    // MARK: helper methods to build url
    private func generateCitySearchUrl(_ query: WeatherSearchRequest)->URLComponents? {
        guard let city = query.city else { return nil }
        var urlComponent = URLComponents()
        urlComponent.scheme = httpProtocol
        urlComponent.host = domain
        urlComponent.path = path
        urlComponent.queryItems = [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: units),
            URLQueryItem(name: "q", value: city)
        ]
        return urlComponent
    }
    
    private func generateZipcodeSearchUrl(_ query: WeatherSearchRequest)->URLComponents? {
        guard let zipcode = query.zip else { return nil }
        var urlComponent = URLComponents()
        urlComponent.scheme = httpProtocol
        urlComponent.host = domain
        urlComponent.path = path
        urlComponent.queryItems = [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: units),
            URLQueryItem(name: "zip", value: zipcode)
        ]
        return urlComponent
    }
    
    private func generateCoordSearchUrl(_ query: WeatherSearchRequest)->URLComponents? {
        guard let coord = query.coord else { return nil }
        let longitude = String(coord.longitude)
        let latitude = String(coord.latitude)
        var urlComponent = URLComponents()
        urlComponent.scheme = httpProtocol
        urlComponent.host = domain
        urlComponent.path = path
        urlComponent.queryItems = [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: units),
            URLQueryItem(name: "lon", value: longitude),
            URLQueryItem(name: "lat", value: latitude)
        ]
        return urlComponent
    }
}

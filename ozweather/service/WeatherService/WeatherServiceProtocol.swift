//
//  WeatherServiceProtocol.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import Foundation

protocol WeatherServiceProtocol {
    
    func searchBy(query: String, completionHandler: @escaping (Result<WeatherLocation, Error>)-> Void)
    func updateRecent(locations: [WeatherLocation], completionHandler: @escaping (Bool) -> Void)
}

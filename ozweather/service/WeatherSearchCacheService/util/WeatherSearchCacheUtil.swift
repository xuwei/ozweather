//
//  WeatherSearchCacheUtil.swift
//  ozweather
//
//  Created by Xuwei Liang on 22/11/20.
//

import Foundation

class WeatherSearchCacheUtil {
    
    // convert WeatherSearchRequest to cache item
    func toWeatherServiceCacheItem(_ req: WeatherSearchRequest)->WeatherSearchCacheItem? {
        switch req.type {
        case .city:
            return WeatherSearchCacheItem(city: req.city, type: .city)
        case .zipCode:
            return WeatherSearchCacheItem(zipCode: req.zip, type: .zipCode)
        case .gpsCoord:
            guard let coord = req.coord else { return nil }
            return WeatherSearchCacheItem(longitude: coord.longitude, latitude: coord.latitude, type: .gpsCoord)
        case .unknown:
            return nil
        }
    }
    
    // convert WeatherLocationCellVM to cache item
    func toWeatherServiceCacheItem(_ vm: WeatherLocationCellVM)->WeatherSearchCacheItem? {
        switch vm.type {
        case .city:
            return WeatherSearchCacheItem(city: vm.text, type: .city)
        case .zipCode:
            return WeatherSearchCacheItem(zipCode: vm.text, type: .zipCode)
        default:
            return nil
        }
    }
}

//
//  CacheManagerProtocol.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import Foundation

protocol WeatherSearchCacheManagerProtocol {
    func getQueue(listName: String) -> [WeatherSearchCacheItem]?
    func enqueue(listName: String, element: WeatherSearchCacheItem) -> [WeatherSearchCacheItem]
    func clearList(listName: String)
}

// utility method for cache manager 
extension WeatherSearchCacheManagerProtocol {
    
    func toWeatherSearchCacheItem(weatherSearchReq: WeatherSearchRequest)->WeatherSearchCacheItem? {
        var cacheItem = WeatherSearchCacheItem()
        switch weatherSearchReq.type {
        case .city:
            guard let city = weatherSearchReq.city else { return nil }
            cacheItem.city = city
        case .zipCode:
            guard let zip = weatherSearchReq.zip else { return nil }
            cacheItem.zipCode = zip
        case .gpsCoord:
            guard let coord = weatherSearchReq.coord else { return nil }
            cacheItem.latitude = coord.latitude
            cacheItem.longitude = coord.longitude
        }
        return cacheItem
    }
}

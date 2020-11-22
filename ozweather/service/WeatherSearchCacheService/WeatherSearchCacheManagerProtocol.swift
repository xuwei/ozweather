//
//  CacheManagerProtocol.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import Foundation

protocol WeatherSearchCacheManagerProtocol {
    func getQueue(listName: SearchCacheListName) -> [WeatherSearchCacheItem]?
    func enqueue(listName: SearchCacheListName, element: WeatherSearchCacheItem) -> [WeatherSearchCacheItem]
    func clearList(listName: SearchCacheListName)
    func clear(listName: SearchCacheListName, item: WeatherSearchCacheItem)->[WeatherSearchCacheItem]
}

// utility method for cache manager 
extension WeatherSearchCacheManagerProtocol {
    
    func toWeatherSearchCacheItem(weatherSearchReq: WeatherSearchRequest)->WeatherSearchCacheItem? {
        var cacheItem = WeatherSearchCacheItem()
        switch weatherSearchReq.type {
        case .city:
            guard let city = weatherSearchReq.city else { return nil }
            cacheItem.city = city
            break
        case .zipCode:
            guard let zip = weatherSearchReq.zip else { return nil }
            cacheItem.zipCode = zip
            break
        case .gpsCoord:
            guard let coord = weatherSearchReq.coord else { return nil }
            cacheItem.latitude = coord.latitude
            cacheItem.longitude = coord.longitude
            break
        case .unknown:
            return nil
        }
        return cacheItem
    }
}

//
//  WeatherSearchCacheMockUtil.swift
//  ozweather
//
//  Created by Xuwei Liang on 21/11/20.
//

import Foundation

class WeatherSearchCacheMockUtil {

    let cities = ["Sydney", "Atlanta", "New York", "Melbourne", "Hong Kong"]
    let zipCodes = ["2000","30301","10001","3000","518003"]
    let coords = [(-33.865143, 151.209900),
                  (33.753746, -84.386330),
                  (40.7127837, -74.0059413),
                  (-37.840935, 144.946457),
                  (22.302711, 114.177216)]
    
    func randomSearchCacheItem() -> WeatherSearchCacheItem {
        let type = WeatherSearchRequestType.AllCases().randomElement()
        switch type {
        case .city:
            return generateSearchByCityItem()
        case .zipCode:
            return generateSearchByZipcodeItem()
        case .gpsCoord:
            return generateSearchByCoordItem()
        default:
            return generateSearchByCityItem()
        }
    }
    
    private func generateSearchByCityItem() -> WeatherSearchCacheItem {
        return WeatherSearchCacheItem(city: cities.randomElement(), type: .city)
    }
    
    private func generateSearchByZipcodeItem() -> WeatherSearchCacheItem {
        return WeatherSearchCacheItem(city: zipCodes.randomElement(), type: .zipCode)
    }
    
    private func generateSearchByCoordItem() -> WeatherSearchCacheItem {
        let coord = coords.randomElement() ?? (0.0,0.0)
        return WeatherSearchCacheItem(longitude: coord.1, latitude: coord.0, type: .gpsCoord)
    }
}

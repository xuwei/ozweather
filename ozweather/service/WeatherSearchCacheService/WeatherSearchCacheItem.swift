//
//  SearchCacheItem.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import Foundation

struct WeatherSearchCacheItem: Codable {
    
    var city: String?
    var zipCode: String?
    var longitude: Double?
    var latitude: Double?
    var type: WeatherSearchRequestType
    
    init(city: String? = nil, zipCode: String? = nil, longitude: Double? = nil, latitude: Double? = nil, type: WeatherSearchRequestType = .city) {
        self.type = type
        switch self.type {
        case .city:
            self.city = city
            break
        case .zipCode:
            self.zipCode = zipCode
            break
        case .gpsCoord:
            self.longitude = longitude
            self.latitude = latitude
            break
        }
    }
}

//
//  WeatherSearchRequest.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import Foundation
import CoreLocation

enum WeatherSearchRequestType {
    case city
    case zipCode
    case gps
}

struct WeatherSearchRequest {
    var city: String?
    var zip: Int?
    var coord: CLLocationCoordinate2D?
    var type: WeatherSearchRequestType
    
    init(city: String? = nil, zip: Int? = nil, coord: CLLocationCoordinate2D? = nil, type: WeatherSearchRequestType) {
        self.city = city
        self.zip = zip
        self.coord = coord
        self.type = type
    }
}

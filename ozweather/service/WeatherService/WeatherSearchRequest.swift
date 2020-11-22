//
//  WeatherSearchRequest.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import Foundation
import CoreLocation

enum WeatherSearchRequestType: Int, Codable, CaseIterable {
    case city
    case zipCode
    case gpsCoord
    case unknown
}

struct WeatherSearchRequest {
    var city: String?
    var zip: String?
    var coord: CLLocationCoordinate2D?
    var type: WeatherSearchRequestType
    
    init(city: String? = nil, zip: String? = nil, coord: CLLocationCoordinate2D? = nil, type: WeatherSearchRequestType) {
        self.city = city
        self.zip = zip
        self.coord = coord
        self.type = type
    }
}


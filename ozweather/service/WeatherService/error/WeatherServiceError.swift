//
//  WeatherServiceError.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import Foundation

let HttpStatusSuccess = 200

enum WeatherServiceError: Error {
    case invalidParam
    case invalidParamFormat
    case GPSNotAvailable
    case genericError
}

extension WeatherServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidParam:
            return "Invalid search parameters"
        case .invalidParamFormat:
            return "Invalid search parameter format. Eg: 'Atlanta' or '30301'"
        case .GPSNotAvailable:
            return "GPS not available"
        case .genericError:
            return "Error has occurred, please try again later"
        }
    }
}

extension WeatherServiceError: Equatable {
    static func == (lhs: WeatherServiceError, rhs: WeatherServiceError)->Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}

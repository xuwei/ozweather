//
//  CoordUtil.swift
//  ozweather
//
//  Created by Xuwei Liang on 23/11/20.
//

import Foundation

struct StringifyUtil {
    func stringify(latitude: Double, longitude: Double)->String {
        return String(format:"lat: %.9f,lon: %.9f", latitude, longitude)
    }
}

//
//  CoordUtil.swift
//  ozweather
//
//  Created by Xuwei Liang on 23/11/20.
//

import Foundation

class StringifyUtil {
    
    static let shared = StringifyUtil()
    private init() {}
    
    func stringifyCoord(latitude: Double, longitude: Double)->String {
        let result = String(format:"lat: %.3f, lon: %.3f", latitude, longitude)
        return result 
    }
}

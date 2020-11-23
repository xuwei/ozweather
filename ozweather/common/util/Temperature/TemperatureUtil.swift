//
//  TempleratureUtil.swift
//  ozweather
//
//  Created by Xuwei Liang on 23/11/20.
//

import Foundation

struct TemperatureUtil {
    
    func getCelsiusFrom(fahrenheit: Double)->Double {
        let result = (fahrenheit - 32) * (5/9)
        return result.round(to: 2)
    }
    
    func getCelsiusFrom(kelvin: Double)->Double {
        let result = kelvin - 273.15
        return result.round(to: 2)
    }
}

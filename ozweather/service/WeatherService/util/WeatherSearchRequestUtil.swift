//
//  WeatherSearchRequestUtil.swift
//  ozweather
//
//  Created by Xuwei Liang on 21/11/20.
//

import Foundation

class WeatherSearchRequestUtil {
    
    func validCharacters(_ text: String)->Bool {
        return true
    }
    
    func typeOfRequest(_ text: String)-> WeatherSearchRequestType {
        return .city
    }
}

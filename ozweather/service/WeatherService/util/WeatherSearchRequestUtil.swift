//
//  WeatherSearchRequestUtil.swift
//  ozweather
//
//  Created by Xuwei Liang on 21/11/20.
//

import Foundation

class WeatherSearchRequestUtil {
    
    let zipcodeCharacters: CharacterSet = CharacterSet(charactersIn: "0123456789")
    let cityCharacters: CharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz ")
    
    // checks if the characters are valid
    func validCharacters(_ text: String)->Bool {
        let loweredCase = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        return zipcodeCharacters.union(cityCharacters).isSuperset(of: CharacterSet(charactersIn: loweredCase))
    }
    
    // only checks for city or zipcode, added gps coord only if scope requires
    func typeOfRequest(_ text: String)-> WeatherSearchRequestType {
        let loweredCase = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if (cityCharacters.isSuperset(of: CharacterSet(charactersIn: loweredCase))) {
            return .city
        } else if (zipcodeCharacters.isSuperset(of: CharacterSet(charactersIn: loweredCase))) {
            return .zipCode
        } else {
            return .unknown
        }
    }
}

//
//  OpenWeatherImageUtil.swift
//  ozweather
//
//  Created by Xuwei Liang on 23/11/20.
//

import Foundation

class OpenWeatherImageUtil {
    
    private let httpProtocol = "https"
    private let imageDomain = "openweathermap.org"
    private let imagePath = "/img/w"
    
    func generateIconImageUrl(_ icon: String)->String? {
        var urlComponent = URLComponents()
        urlComponent.scheme = httpProtocol
        urlComponent.host = imageDomain
        urlComponent.path = imagePath
        urlComponent.path.append("/\(icon).png")
        guard let url = urlComponent.url else { return nil }
        return url.absoluteString
    }
}

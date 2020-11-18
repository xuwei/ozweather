//
//  OpenWeatherServiceIntegrationTests.swift
//  ozweatherTests
//
//  Created by Xuwei Liang on 19/11/20.
//

import XCTest
@testable import ozweather

class OpenWeatherServiceIntegrationTests: NSObject {
    
    let service: WeatherServiceProtocol = OpenWeatherAPI.shared
    
    func testSearchByCity() {
        XCTAssertTrue(false)
    }
    
    func testSearchByInvalidCity() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSearchByPostcode() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSearchByInvalidPostcode() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}

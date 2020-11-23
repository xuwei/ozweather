//
//  TemperatureUtilTests.swift
//  ozweatherTests
//
//  Created by Xuwei Liang on 23/11/20.
//

import XCTest
@testable import ozweather

class TemperatureUtilTests: XCTestCase {

    func testPositiveKelvin() {
        let result = TemperatureUtil().getCelsiusFrom(kelvin: 280)
        XCTAssertTrue(result == 6.85)
    }
    
    func testZeroKelvin() {
        let result = TemperatureUtil().getCelsiusFrom(kelvin: 0)
        XCTAssertTrue(result == -273.15)
    }
    
    func testNegativeKelvin() {
        let result = TemperatureUtil().getCelsiusFrom(kelvin: -100)
        XCTAssertTrue(result == -373.15)
    }
    
    func testPositiveFahrenheit() {
        let result = TemperatureUtil().getCelsiusFrom(fahrenheit: 100)
        XCTAssertTrue(result == 37.78)
    }
    
    func testZeroFahrenheit() {
        let result = TemperatureUtil().getCelsiusFrom(fahrenheit: 0)
        XCTAssertTrue(result == -17.78)
    }
    
    func testNegativeFahrenheit() {
        let result = TemperatureUtil().getCelsiusFrom(fahrenheit: -100)
        XCTAssertTrue(result == -73.33)
    }
}

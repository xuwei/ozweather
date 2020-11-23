//
//  WeatherSearchCacheItemTests.swift
//  ozweatherTests
//
//  Created by Xuwei Liang on 21/11/20.
//

import XCTest
@testable import ozweather

class WeatherSearchCacheItemTests: XCTestCase {

    func testToStringForCity() {
        let cacheItem = WeatherSearchCacheItem(city: "Atlanta", type: .city)
        XCTAssertTrue(cacheItem.stringify() == "Atlanta")
    }
    
    func testToStringForZipcode() {
        let cacheItem = WeatherSearchCacheItem(zipCode: "30301", type: .zipCode)
        XCTAssertTrue(cacheItem.stringify() == "30301")
    }
    
    func testToStringForCoord() {
        let cacheItem = WeatherSearchCacheItem(longitude: 30.0, latitude: -30.002, type: .gpsCoord)
        let result = cacheItem.stringify()
        XCTAssertTrue(result == "lat: -30.002, lon: 30.000")
    }
}

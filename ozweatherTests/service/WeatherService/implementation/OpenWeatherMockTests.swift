//
//  OpenWeatherMockTests.swift
//  ozweatherTests
//
//  Created by Xuwei Liang on 20/11/20.
//

import XCTest
@testable import ozweather

class OpenWeatherMockTests: XCTestCase {

    let service: WeatherServiceProtocol = OpenWeatherServiceMock.shared
    
    func testSearchByCity() {
        let expectation = XCTestExpectation(description: "search by valid city name")
        let cityName = "Atlanta"
        let searchReq = WeatherSearchRequest(city: cityName, type: .city)
        service.searchBy(query: searchReq) { result in
            switch(result) {
            case .success(let location):
                let weather: WeatherForecast = location
                XCTAssertTrue(weather.name == cityName)
//                XCTAssertTrue(weather.timezone == -18000)
//                XCTAssertNotNil(weather.coord)
//                XCTAssertNotNil(weather.country)
//                XCTAssertNotNil(weather.temperature)
//                XCTAssertNotNil(weather.wind)
//                XCTAssertNotNil(weather.weather)
                expectation.fulfill()
                break
            case .failure(_):
                XCTFail()
                expectation.fulfill()
                break
            }
        }
        
        wait(for: [expectation], timeout: XCTestConfig.integrationTestTimeout)
    }
    
    func testSearchByInvalidCity() {
        let expectation = XCTestExpectation(description: "search by valid city name")
        let cityName = "Atttlanta"
        let searchReq = WeatherSearchRequest(city: cityName, type: .city)
        service.searchBy(query: searchReq) { result in
            switch(result) {
            case .success(_):
                XCTFail()
                expectation.fulfill()
                break
            case .failure(let error):
                XCTAssertTrue(error == .invalidParam)
                XCTAssertNotNil(error)
                expectation.fulfill()
                break
            }
        }
        
        wait(for: [expectation], timeout: XCTestConfig.integrationTestTimeout)
    }

    func testSearchByPostcode() {
        let expectation = XCTestExpectation(description: "search by valid zip code")
        let cityName = "Atlanta"
        let zipCode = "30303"
        let searchReq = WeatherSearchRequest(zip: zipCode, type: .zipCode)
        service.searchBy(query: searchReq) { result in
            switch(result) {
            case .success(let location):
                let weather: WeatherForecast = location
                XCTAssertTrue(weather.name == cityName)
//                XCTAssertTrue(weather.timezone == -18000)
//                XCTAssertNotNil(weather.coord)
//                XCTAssertNotNil(weather.country)
//                XCTAssertNotNil(weather.temperature)
//                XCTAssertNotNil(weather.wind)
//                XCTAssertNotNil(weather.weather)
                expectation.fulfill()
                break
            case .failure(_):
                XCTFail()
                expectation.fulfill()
                break
            }
        }
        
        wait(for: [expectation], timeout: XCTestConfig.integrationTestTimeout)
    }

    func testSearchByInvalidPostcode() {
        let expectation = XCTestExpectation(description: "search by invalid zip code")
        let zipCode = "30301"
        let searchReq = WeatherSearchRequest(zip: zipCode, type: .zipCode)
        service.searchBy(query: searchReq) { result in
            switch(result) {
            case .success(_):
                XCTFail()
                expectation.fulfill()
                break
            case .failure(let err):
                XCTAssertTrue(err == .invalidParam)
                expectation.fulfill()
                break
            }
        }
        
        wait(for: [expectation], timeout: XCTestConfig.integrationTestTimeout)
    }
}

//
//  OpenWeatherServiceIntegrationTests.swift
//  ozweatherTests
//
//  Created by Xuwei Liang on 19/11/20.
//

import XCTest
import CoreLocation
@testable import ozweather

class OpenWeatherAPIIntegrationTests: XCTestCase {
    
    let service: WeatherServiceProtocol = OpenWeatherService.shared
    
    func testSearchByCity() {
        let expectation = XCTestExpectation(description: "search by valid city name")
        let cityName = "Atlanta"
        let searchReq = WeatherSearchRequest(city: cityName, type: .city)
        service.searchBy(query: searchReq) { result in
            switch(result) {
            case .success(let forecast):
                let weather: WeatherForecast = forecast
                XCTAssertTrue(weather.name == cityName)
                XCTAssertTrue(weather.timezone == -18000)
                XCTAssertNotNil(weather.coord)
                XCTAssertNotNil(weather.country)
                XCTAssertNotNil(weather.temperature)
                XCTAssertNotNil(weather.wind)
                XCTAssertNotNil(weather.weather)
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
                XCTAssertTrue(weather.timezone == -18000)
                XCTAssertNotNil(weather.coord)
                XCTAssertNotNil(weather.country)
                XCTAssertNotNil(weather.temperature)
                XCTAssertNotNil(weather.wind)
                XCTAssertNotNil(weather.weather)
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
        let expectation = XCTestExpectation(description: "search by valid zip code")
        let zipCode = "999999999"
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
    
    func testSearchByCoord() {
        let expectation = XCTestExpectation(description: "search by valid zip code")
        let coord = CLLocationCoordinate2D(latitude: -84.39, longitude: 33.75)
        let searchReq = WeatherSearchRequest(coord: coord, type: .gpsCoord)
        service.searchBy(query: searchReq) { result in
            switch(result) {
            case .success(let forecast):
                XCTAssertNotNil(forecast.weather)
                XCTAssertTrue(forecast.name.isEmpty)
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
    
    func testSearchByInvalidCoordLatitude() {
        let expectation = XCTestExpectation(description: "search by valid zip code")
        let coord = CLLocationCoordinate2D(latitude: -1000.39, longitude: 10.0)
        let searchReq = WeatherSearchRequest(coord: coord, type: .gpsCoord)
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
    
    func testSearchByInvalidCoordLongitude() {
        let expectation = XCTestExpectation(description: "search by valid zip code")
        let coord = CLLocationCoordinate2D(latitude: -10.39, longitude: 1000.39)
        let searchReq = WeatherSearchRequest(coord: coord, type: .gpsCoord)
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

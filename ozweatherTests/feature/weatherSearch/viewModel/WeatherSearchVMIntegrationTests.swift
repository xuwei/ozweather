//
//  WeatherSearchVMIntegrationTests.swift
//  ozweatherTests
//
//  Created by Xuwei Liang on 23/11/20.
//

import XCTest
import UIKit
import CoreLocation
@testable import ozweather

class WeatherSearchVMIntegrationTests: XCTestCase {
    
    // using mock for location and weather service, as we want to test the cache
    let searchVMWithCache = WeatherSearchVM(searchCache: WeatherSearchCache.shared, weatheService: OpenWeatherAPIMock.shared, locationService: WLocationServiceMock.shared)
    
    // using mock for cache and location service, using this variable for api integration test
    let searchVMWithAPI = WeatherSearchVM(searchCache: WeatherSearchCacheMock.shared, weatheService: OpenWeatherAPI.shared, locationService: WLocationServiceMock.shared)
        
    override func setUp() {
        WeatherSearchCache.shared.clearList(listName: .testSearchCacheList)
        searchVMWithCache.listName = .testSearchCacheList
    }
    
    func testLoadRecentEmpty() {
        let expectation = XCTestExpectation(description: "load recent")
        // using mock for weather service and location service
        searchVMWithCache.loadRecent { [weak self] in
            guard let self = self else { return }
            XCTAssertNotNil(self.searchVMWithCache.sections)
            XCTAssertNotNil(self.searchVMWithCache.sections[1].cellVMList)
            XCTAssertTrue(self.searchVMWithCache.sections[1].cellVMList.count == 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: XCTestConfig.integrationTestTimeout)
    }
    
    func testSaveRecent() {
        let expectation = XCTestExpectation(description: "save recent")
        searchVMWithCache.saveRecent(WeatherSearchRequest(city: "Atlanta", type: .city))
        searchVMWithCache.saveRecent(WeatherSearchRequest(zip: "30301", type: .zipCode))
        searchVMWithCache.loadRecent { [weak self] in
            guard let self = self else { return }
            XCTAssertNotNil(self.searchVMWithCache.sections)
            XCTAssertNotNil(self.searchVMWithCache.sections[1].cellVMList)
            XCTAssertTrue(self.searchVMWithCache.sections[1].cellVMList.count == 2)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: XCTestConfig.integrationTestTimeout)
    }
    
    func testDeleteRecent() {
        let expectation = XCTestExpectation(description: "save recent")
        searchVMWithCache.saveRecent(WeatherSearchRequest(city: "Atlanta", type: .city))
        searchVMWithCache.saveRecent(WeatherSearchRequest(zip: "30301", type: .zipCode))
        let atlanta = WeatherLocationCellVM(text: "Atlanta", type: .city)
        let zipcode = WeatherLocationCellVM(text: "30301", type: .zipCode)
        searchVMWithCache.removeRecent(atlanta)
        searchVMWithCache.removeRecent(zipcode)
        searchVMWithCache.loadRecent { [weak self] in
            guard let self = self else { return }
            XCTAssertNotNil(self.searchVMWithCache.sections)
            XCTAssertNotNil(self.searchVMWithCache.sections[1].cellVMList)
            XCTAssertTrue(self.searchVMWithCache.sections[1].cellVMList.count == 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: XCTestConfig.integrationTestTimeout)
    }
    
    func testDeleteRecentNonExisting() {
        let expectation = XCTestExpectation(description: "save recent")
        searchVMWithCache.saveRecent(WeatherSearchRequest(city: "Atlanta", type: .city))
        searchVMWithCache.saveRecent(WeatherSearchRequest(zip: "30301", type: .zipCode))
        let hongKong = WeatherLocationCellVM(text: "Hong Kong", type: .city)
        let zipcode = WeatherLocationCellVM(text: "2000", type: .zipCode)
        searchVMWithCache.removeRecent(hongKong)
        searchVMWithCache.removeRecent(zipcode)
        searchVMWithCache.loadRecent { [weak self] in
            guard let self = self else { return }
            XCTAssertNotNil(self.searchVMWithCache.sections)
            XCTAssertNotNil(self.searchVMWithCache.sections[1].cellVMList)
            XCTAssertTrue(self.searchVMWithCache.sections[1].cellVMList.count == 2)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: XCTestConfig.integrationTestTimeout)
    }
    
    func testDeleteRecentInvalidType() {
        let expectation = XCTestExpectation(description: "save recent")
        searchVMWithCache.saveRecent(WeatherSearchRequest(city: "Atlanta", type: .city))
        searchVMWithCache.saveRecent(WeatherSearchRequest(zip: "30301", type: .zipCode))
        let invalid1 = WeatherLocationCellVM(text: "-30.0,30.0", type: .gpsCoord)
        let invalid2 = WeatherLocationCellVM(text: "@home", type: .unknown)
        searchVMWithCache.removeRecent(invalid1)
        searchVMWithCache.removeRecent(invalid2)
        searchVMWithCache.loadRecent { [weak self] in
            guard let self = self else { return }
            XCTAssertNotNil(self.searchVMWithCache.sections)
            XCTAssertNotNil(self.searchVMWithCache.sections[1].cellVMList)
            XCTAssertTrue(self.searchVMWithCache.sections[1].cellVMList.count == 2)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: XCTestConfig.integrationTestTimeout)
    }
}

// MARK: integration test with search api
extension WeatherSearchVMIntegrationTests {
    
    func testSearchValidCity () {
        let expectation = XCTestExpectation(description: "search valid city")
        let request = WeatherSearchRequest(city: "Atlanta", type: .city)
        searchVMWithAPI.queueSearch(request) { result in
            switch result {
            case .success(let forecast):
                XCTAssertTrue(forecast.name == "Atlanta")
                XCTAssertNotNil(forecast.weather)
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
    
    func testSearchValidZipcode () {
        let expectation = XCTestExpectation(description: "search valid zipcode")
        let request = WeatherSearchRequest(zip: "30301", type: .zipCode)
        searchVMWithAPI.queueSearch(request) { result in
            switch result {
            case .success(let forecast):
                XCTAssertTrue(forecast.name == "Atlanta")
                XCTAssertNotNil(forecast.weather)
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
    
    func testSearchInvalidFormat1 () {
        let expectation = XCTestExpectation(description: "search invalid request")
        let request = WeatherSearchRequest(zip: "Atlanta", type: .zipCode)
        searchVMWithAPI.queueSearch(request) { result in
            switch result {
            case .success(_):
                XCTFail()
                expectation.fulfill()
                break
            case .failure(let err):
                XCTAssertNotNil(err)
                expectation.fulfill()
                break
            }
        }
        wait(for: [expectation], timeout: XCTestConfig.integrationTestTimeout)
    }
    
    // queueSearch method from search viewModel should only support city and zipcode
    func testSearchInvalidFormat2 () {
        let expectation = XCTestExpectation(description: "search invalid request")
        let coord = CLLocationCoordinate2D(latitude: -30.0, longitude: -30.0)
        let request = WeatherSearchRequest(coord: coord, type: .gpsCoord)
        searchVMWithAPI.queueSearch(request) { result in
            switch result {
            case .success(_):
                XCTFail()
                expectation.fulfill()
                break
            case .failure(let err):
                XCTAssertNotNil(err)
                expectation.fulfill()
                break
            }
        }
        wait(for: [expectation], timeout: XCTestConfig.integrationTestTimeout)
    }
    
    func testToSearchRequestValidCity() {
        guard let result = searchVMWithAPI.toSearchRequest("Atlanta") else { XCTFail(); return }
        XCTAssertTrue(result.type == .city)
        XCTAssertNotNil(result.city == "Atlanta")
        XCTAssertNil(result.zip)
        XCTAssertNil(result.coord)
    }
    
    func testToSearchRequestValidZipcode() {
        guard let result = searchVMWithAPI.toSearchRequest("30301") else { XCTFail(); return }
        XCTAssertTrue(result.type == .zipCode)
        XCTAssertNotNil(result.zip == "30301")
        XCTAssertNil(result.city)
        XCTAssertNil(result.coord)
    }
    
    func testToSearchRequestInvalid1() {
        let result = searchVMWithAPI.toSearchRequest("Atlanta 30301")
        XCTAssertNil(result)
    }
    
    func testToSearchRequestInvalid2() {
        let result = searchVMWithAPI.toSearchRequest("-30.0,30.0")
        XCTAssertNil(result)
    }
    
    func testToSearchRequestInvalid3() {
        let result = searchVMWithAPI.toSearchRequest("2000 Sydney")
        XCTAssertNil(result)
    }
    
    func testToSearchRequestInvalid4() {
        let result = searchVMWithAPI.toSearchRequest("@home")
        XCTAssertNil(result)
    }
    
    func testToSearchRequestInvalid5() {
        let result = searchVMWithAPI.toSearchRequest("New-York")
        XCTAssertNil(result)
    }
}

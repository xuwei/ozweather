//
//  WeatherSearchVMIntegrationTests.swift
//  ozweatherTests
//
//  Created by Xuwei Liang on 23/11/20.
//

import XCTest
import UIKit
@testable import ozweather

class WeatherSearchVMIntegrationTests: XCTestCase {
    
    // using mock for location and weather service, as we want to test the cache
    let searchVM = WeatherSearchVM(searchCache: WeatherSearchCache.shared, weatheService: OpenWeatherAPIMock.shared, locationService: WLocationServiceMock.shared)
    
    override func setUp() {
        WeatherSearchCache.shared.clearList(listName: .testSearchCacheList)
        searchVM.listName = .testSearchCacheList
    }
    
    func testLoadRecentEmpty() {
        let expectation = XCTestExpectation(description: "load recent")
        // using mock for weather service and location service
        searchVM.loadRecent { [weak self] in
            guard let self = self else { return }
            XCTAssertNotNil(self.searchVM.sections)
            XCTAssertNotNil(self.searchVM.sections[1].cellVMList)
            XCTAssertTrue(self.searchVM.sections[1].cellVMList.count == 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: XCTestConfig.integrationTestTimeout)
    }
    
    func testSaveRecent() {
        let expectation = XCTestExpectation(description: "save recent")
        searchVM.saveRecent(WeatherSearchRequest(city: "Atlanta", type: .city))
        searchVM.saveRecent(WeatherSearchRequest(zip: "30301", type: .zipCode))
        searchVM.loadRecent { [weak self] in
            guard let self = self else { return }
            XCTAssertNotNil(self.searchVM.sections)
            XCTAssertNotNil(self.searchVM.sections[1].cellVMList)
            XCTAssertTrue(self.searchVM.sections[1].cellVMList.count == 2)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: XCTestConfig.integrationTestTimeout)
    }
    
    func testDeleteRecent() {
        let expectation = XCTestExpectation(description: "save recent")
        searchVM.saveRecent(WeatherSearchRequest(city: "Atlanta", type: .city))
        searchVM.saveRecent(WeatherSearchRequest(zip: "30301", type: .zipCode))
        let atlanta = WeatherLocationCellVM(text: "Atlanta", type: .city)
        let zipcode = WeatherLocationCellVM(text: "30301", type: .zipCode)
        searchVM.removeRecent(atlanta)
        searchVM.removeRecent(zipcode)
        searchVM.loadRecent { [weak self] in
            guard let self = self else { return }
            XCTAssertNotNil(self.searchVM.sections)
            XCTAssertNotNil(self.searchVM.sections[1].cellVMList)
            XCTAssertTrue(self.searchVM.sections[1].cellVMList.count == 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: XCTestConfig.integrationTestTimeout)
    }
    
    func testDeleteRecentNonExisting() {
        let expectation = XCTestExpectation(description: "save recent")
        searchVM.saveRecent(WeatherSearchRequest(city: "Atlanta", type: .city))
        searchVM.saveRecent(WeatherSearchRequest(zip: "30301", type: .zipCode))
        let hongKong = WeatherLocationCellVM(text: "Hong Kong", type: .city)
        let zipcode = WeatherLocationCellVM(text: "2000", type: .zipCode)
        searchVM.removeRecent(hongKong)
        searchVM.removeRecent(zipcode)
        searchVM.loadRecent { [weak self] in
            guard let self = self else { return }
            XCTAssertNotNil(self.searchVM.sections)
            XCTAssertNotNil(self.searchVM.sections[1].cellVMList)
            XCTAssertTrue(self.searchVM.sections[1].cellVMList.count == 2)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: XCTestConfig.integrationTestTimeout)
    }
    
    func testDeleteRecentInvalidType() {
        let expectation = XCTestExpectation(description: "save recent")
        searchVM.saveRecent(WeatherSearchRequest(city: "Atlanta", type: .city))
        searchVM.saveRecent(WeatherSearchRequest(zip: "30301", type: .zipCode))
        let invalid1 = WeatherLocationCellVM(text: "-30.0,30.0", type: .gpsCoord)
        let invalid2 = WeatherLocationCellVM(text: "@home", type: .unknown)
        searchVM.removeRecent(invalid1)
        searchVM.removeRecent(invalid2)
        searchVM.loadRecent { [weak self] in
            guard let self = self else { return }
            XCTAssertNotNil(self.searchVM.sections)
            XCTAssertNotNil(self.searchVM.sections[1].cellVMList)
            XCTAssertTrue(self.searchVM.sections[1].cellVMList.count == 2)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: XCTestConfig.integrationTestTimeout)
    }
}

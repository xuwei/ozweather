//
//  WeatherSearchCacheTests.swift
//  ozweatherTests
//
//  Created by Xuwei Liang on 20/11/20.
//

import XCTest
@testable import ozweather

class WeatherSearchCacheTests: XCTestCase {

    let cache: WeatherSearchCacheManagerProtocol = WeatherSearchCache.shared
    let cacheQueueName = "testQueue"
    
    override func setUp() {
        cache.clearList(listName: .testSearchCacheList)
    }
    
    func testEnqueueAndGetQeue() {
        let item1 = WeatherSearchCacheItem(city: "Atlanta", zipCode: nil, longitude: nil, latitude: nil, type: .city)
        var items = cache.enqueue(listName: .testSearchCacheList, element: item1)
        XCTAssertTrue(items.count == 1)
    
        items = cache.getQueue(listName: .testSearchCacheList) ?? []
        XCTAssertTrue(items.count == 1)
    }
    
    func testEnqueueDuplicates() {
        let item1 = WeatherSearchCacheItem(city: "Atlanta", zipCode: nil, longitude: nil, latitude: nil, type: .city)
        let item2 = WeatherSearchCacheItem(city: "Hong Kong", zipCode: nil, longitude: nil, latitude: nil, type: .city)
        
        var items = cache.enqueue(listName: .testSearchCacheList, element: item1)
        items = cache.enqueue(listName: .testSearchCacheList, element: item2)
        items = cache.enqueue(listName: .testSearchCacheList, element: item1)
        XCTAssertTrue(items.count == 2)
        guard let last = items.last else { XCTFail(); return }
        XCTAssertTrue(last == item1)
        items = cache.getQueue(listName: .testSearchCacheList) ?? []
        XCTAssertTrue(items.count == 2)
    }

    func testClearlist() {
        let item1 = WeatherSearchCacheItem(city: "Atlanta", zipCode: nil, longitude: nil, latitude: nil, type: .city)
        
        let item2 = WeatherSearchCacheItem(city: "Chicago", zipCode: nil, longitude: nil, latitude: nil, type: .city)
        
        var items = cache.enqueue(listName: .testSearchCacheList, element: item1)
        items = cache.enqueue(listName: .testSearchCacheList, element: item2)
        XCTAssertTrue(items.count == 2)
        cache.clearList(listName: .searchCacheList)
        items = cache.getQueue(listName: .testSearchCacheList) ?? []
        XCTAssertTrue(items.count == 2)
        cache.clearList(listName: .testSearchCacheList)
        items = cache.getQueue(listName: .testSearchCacheList) ?? []
        XCTAssertTrue(items.count == 0)
    }
    
    func testEnqueueMoreThanMax() {
        
        for index in 0...1000 {
            let item = WeatherSearchCacheItem(zipCode: String(index), type: .zipCode)
            let _ = cache.enqueue(listName: .testSearchCacheList, element: item)
        }
        
        let items = cache.getQueue(listName: .testSearchCacheList) ?? []
        XCTAssertTrue(items.count == WeatherSearchCache.shared.cacheMax)
        guard let last = items.last else { XCTFail(); return }
        XCTAssertTrue(last.zipCode == "1000")
    }
}

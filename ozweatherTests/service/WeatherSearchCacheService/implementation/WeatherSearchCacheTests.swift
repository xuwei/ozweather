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
    
    func testEnqueueAndGetQeue() {
        cache.clearList(listName: cacheQueueName)
        let item1 = WeatherSearchCacheItem(city: "Atlanta", zipCode: nil, longitude: nil, latitude: nil, type: .city)
        var items = cache.enqueue(listName: cacheQueueName, element: item1)
        XCTAssertTrue(items.count == 1)
    
        items = cache.getQueue(listName: cacheQueueName) ?? []
        XCTAssertTrue(items.count == 1)
    }
    
    func testEnqueueDuplicates() {
        cache.clearList(listName: cacheQueueName)
        let item1 = WeatherSearchCacheItem(city: "Atlanta", zipCode: nil, longitude: nil, latitude: nil, type: .city)
        let item2 = WeatherSearchCacheItem(city: "Hong Kong", zipCode: nil, longitude: nil, latitude: nil, type: .city)
        
        var items = cache.enqueue(listName: cacheQueueName, element: item1)
        items = cache.enqueue(listName: cacheQueueName, element: item2)
        items = cache.enqueue(listName: cacheQueueName, element: item1)
        XCTAssertTrue(items.count == 2)
        guard let last = items.last else { XCTFail(); return }
        XCTAssertTrue(last == item1)
        items = cache.getQueue(listName: cacheQueueName) ?? []
        XCTAssertTrue(items.count == 2)
    }

    func testClearlist() {
        cache.clearList(listName: cacheQueueName)
        let item1 = WeatherSearchCacheItem(city: "Atlanta", zipCode: nil, longitude: nil, latitude: nil, type: .city)
        
        let item2 = WeatherSearchCacheItem(city: "Chicago", zipCode: nil, longitude: nil, latitude: nil, type: .city)
        
        var items = cache.enqueue(listName: cacheQueueName, element: item1)
        items = cache.enqueue(listName: cacheQueueName, element: item2)
        XCTAssertTrue(items.count == 2)
        cache.clearList(listName: "abc")
        items = cache.getQueue(listName: cacheQueueName) ?? []
        XCTAssertTrue(items.count == 2)
        cache.clearList(listName: cacheQueueName)
        items = cache.getQueue(listName: cacheQueueName) ?? []
        XCTAssertTrue(items.count == 0)
    }
}

//
//  WeatherServiceCacheMockTests.swift
//  ozweatherTests
//
//  Created by Xuwei Liang on 21/11/20.
//

import XCTest
@testable import ozweather

class WeatherServiceCacheMockTests: XCTestCase {

    let cache: WeatherSearchCacheManagerProtocol = WeatherSearchCacheMock.shared
    let cacheQueueName = "testQueue"
    
    func testEnqueueAndGetQeue() {
        cache.clearList(listName: .testSearchCacheList)
        let dummy = WeatherSearchCacheItem(city: "Atlanta", zipCode: nil, longitude: nil, latitude: nil, type: .city)
        let queue1 = cache.enqueue(listName: .testSearchCacheList, element: dummy)
        XCTAssertTrue(queue1.count == 100)
        let queue2 = cache.getQueue(listName: .testSearchCacheList) ?? []
        XCTAssertNotNil(queue2)
        XCTAssertTrue(queue2.count == 100)
    }
}

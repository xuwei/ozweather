//
//  RecentCacheManager.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import Foundation

class WeatherSearchCacheMock: WeatherSearchCacheManagerProtocol {
    
    static let shared = WeatherSearchCacheMock()
    private init () { }
    
    func getQueue(listName: SearchCacheListName) -> [WeatherSearchCacheItem]? {
        return randomQueue()
    }
    
    func enqueue(listName: SearchCacheListName, element: WeatherSearchCacheItem) -> [WeatherSearchCacheItem] {
        return randomQueue()
    }
    
    func clearList(listName: SearchCacheListName) {
        return
    }
    
    func clear(listName: SearchCacheListName, item: WeatherSearchCacheItem)->[WeatherSearchCacheItem] {
        return randomQueue()
    }
    
    private func randomQueue()->[WeatherSearchCacheItem] {
        var queue: [WeatherSearchCacheItem] = []
        let mockUtil = WeatherSearchCacheMockUtil()
        for _ in 0..<100 {
            queue.append(mockUtil.randomSearchCacheItem())
        }
        return queue
    }
}

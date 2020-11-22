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
    
    func getQueue(listName: String) -> [WeatherSearchCacheItem]? {
        return randomQueue()
    }
    
    func enqueue(listName: String, element: WeatherSearchCacheItem) -> [WeatherSearchCacheItem] {
        return randomQueue()
    }
    
    func clearList(listName: String) {
        return
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

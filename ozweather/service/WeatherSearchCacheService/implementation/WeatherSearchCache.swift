//
//  RecentCacheManager.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import Foundation

class WeatherSearchCache: WeatherSearchCacheManagerProtocol {
    
    static let shared = WeatherSearchCache()
    private init () { }
    
    func getQueue(listName: String) -> [WeatherSearchCacheItem]? {
        let userDefaults = UserDefaults.standard
        guard let arr: [WeatherSearchCacheItem] = userDefaults.customObjectArray(forKey: listName) else { return nil }
        return arr
    }
    
    func enqueue(listName: String, element: WeatherSearchCacheItem) -> [WeatherSearchCacheItem] {
        let userDefaults = UserDefaults.standard
        var arr: [WeatherSearchCacheItem] = []
        if let existingArr: [WeatherSearchCacheItem] = userDefaults.customObjectArray(forKey: listName) { arr = existingArr }
        arr.append(element)
        do {
            try userDefaults.setCustomObject(arr, forKey: listName)
            return arr
        } catch let err {
            print(err)
            return []
        }
    }
    
    func clearList(listName: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: listName)
    }
}

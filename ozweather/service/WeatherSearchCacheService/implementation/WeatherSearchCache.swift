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
    
    func getQueue(listName: SearchCacheListName) -> [WeatherSearchCacheItem]? {
        let userDefaults = UserDefaults.standard
        guard let arr: [WeatherSearchCacheItem] = userDefaults.customObjectArray(forKey: listName.rawValue) else { return nil }
        return arr
    }
    
    func enqueue(listName: SearchCacheListName, element: WeatherSearchCacheItem) -> [WeatherSearchCacheItem] {
        let userDefaults = UserDefaults.standard
        var arr: [WeatherSearchCacheItem] = []
        if let existingArr: [WeatherSearchCacheItem] = userDefaults.customObjectArray(forKey: listName.rawValue) { arr = existingArr }
        
        // then check any previous element thats duplicated, and remove it
        var filtered = arr.filter { elem in
            return elem != element
        }
    
        // add new element to end first
        filtered.append(element)
        
        do {
            try userDefaults.setCustomObject(filtered, forKey: listName.rawValue)
            return filtered
        } catch let err {
            print(err)
            return []
        }
    }
    
    func clearList(listName: SearchCacheListName) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: listName.rawValue)
    }
    
    func clear(listName: SearchCacheListName, item: WeatherSearchCacheItem)->[WeatherSearchCacheItem] {
        let userDefaults = UserDefaults.standard
        if let existingArr: [WeatherSearchCacheItem] = userDefaults.customObjectArray(forKey: listName.rawValue) {
            let filtered = existingArr.filter { elem in
                elem != item
            }
            
            do {
                try userDefaults.setCustomObject(filtered, forKey: listName.rawValue)
                return filtered
            } catch let err {
                print(err)
                return []
            }
        }
        return [] 
    }
}

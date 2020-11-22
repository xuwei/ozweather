//
//  WeatherSearchVM.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import Foundation

struct WeatherSearchSection {
    let title: String
    let cellVMList: [TableViewCellVMProtocol]
}

class WeatherSearchVM {
    
    // for dependency injection
    convenience init(searchCache: WeatherSearchCacheManagerProtocol, weatheService: WeatherServiceProtocol) {
        self.init()
        self.searchCache = searchCache
        self.weatheService = weatheService
    }
    
    private var weatheService: WeatherServiceProtocol = OpenWeatherAPI.shared
    private var searchCache: WeatherSearchCacheManagerProtocol = WeatherSearchCache.shared
    let title = ScreenName.search.rawValue
    
    private let defaultUseGPSCellTitle = "Use my current location"
    private let defaultUseGPSCellCaption = "requires permission to detect location"
    var sections: [WeatherSearchSection] = []
    
    func loadRecent(_ completionHandler: @escaping (Result<Bool, Error>)->Void) {
        self.updateSectionList()
        completionHandler(.success(true))
    }
    
    func removeRecent(_ vm: WeatherLocationCellVM, completionHandler: @escaping ()->Void) {
        // remove from searchCache
        guard let cacheItem = WeatherSearchCacheUtil().toWeatherServiceCacheItem(vm) else { return }
        let _ = self.searchCache.clear(listName: .searchCacheList,item: cacheItem)
        self.updateSectionList()
        completionHandler()
    }
    
    private func updateSectionList() {
        var sections: [WeatherSearchSection] = []
        let gpsSection = loadUseGPSSection()
        let recentSection = loadRecentSection()
        sections.append(gpsSection)
        sections.append(recentSection)
        self.sections = sections
    }
    
    func saveRecent(_ req: WeatherSearchRequest) {
        // cache search result
        guard let cacheItem = WeatherSearchCacheUtil().toWeatherServiceCacheItem(req) else { return }
        let _  = self.searchCache.enqueue(listName: .searchCacheList, element: cacheItem)
        self.updateSectionList()
    }
    
    private func loadUseGPSSection()->WeatherSearchSection {
        let sectionTitle = "current location"
        let gpsLocation = UseGPSLocationCellVM(title: defaultUseGPSCellTitle, caption: defaultUseGPSCellCaption)
        return WeatherSearchSection(title: sectionTitle, cellVMList:  [gpsLocation])
    }
    
    private func loadRecentSection()->WeatherSearchSection {
        let sectionTitle = "most recent"
        var result: [TableViewCellVMProtocol] = []
        if let recents = searchCache.getQueue(listName: .searchCacheList) {
            // newly added on top, so recents.reversed()
            for cacheItem in recents.reversed() {
                let vm: WeatherLocationCellVM = WeatherLocationCellVM(text: cacheItem.stringify(), type: cacheItem.type)
                result.append(vm)
            }
        }
        
        let section = WeatherSearchSection(title: sectionTitle, cellVMList: result)
        return section
    }
    
    func queueSearch(_ req: WeatherSearchRequest, completionHandler: @escaping (Result<WeatherForecast, WeatherServiceError>)->Void) {
        weatheService.searchBy(query: req) { result in
            completionHandler(result)
        }
    }
}


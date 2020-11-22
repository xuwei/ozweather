//
//  WeatherSearchVM.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import Foundation
import CoreLocation

struct WeatherSearchSection {
    let title: String
    let cellVMList: [TableViewCellVMProtocol]
}

class WeatherSearchVM {
    
    // use real service by default, unless we overriden with mock for dev/test purpose
    private var weatheService: WeatherServiceProtocol = OpenWeatherAPI.shared
    private var searchCache: WeatherSearchCacheManagerProtocol = WeatherSearchCache.shared
    private var locationService: WLocationServiceProtocol = WLocationService.shared
    private var location: CLLocation?
    
    // for dependency injection
    convenience init(searchCache: WeatherSearchCacheManagerProtocol, weatheService: WeatherServiceProtocol, locationService: WLocationServiceProtocol) {
        self.init()
        self.searchCache = searchCache
        self.weatheService = weatheService
        self.locationService = locationService
    }
    
    let title = ScreenName.search.rawValue
    
    private let defaultUseGPSCellTitle = "Use my current location"
    private let defaultUseGPSCellCaption = "requires permission to detect location"
    var sections: [WeatherSearchSection] = []
    
    private func updateSectionList() {
        var sections: [WeatherSearchSection] = []
        let gpsSection = loadUseGPSSection()
        let recentSection = loadRecentSection()
        sections.append(gpsSection)
        sections.append(recentSection)
        self.sections = sections
    }
    
    private func loadUseGPSSection()->WeatherSearchSection {
        let sectionTitle = "current location"
        var gpsLocation: UseGPSLocationCellVM
        if let location =  self.location {
            gpsLocation = UseGPSLocationCellVM(title: defaultUseGPSCellTitle, caption: location.stringify())
        } else {
            gpsLocation = UseGPSLocationCellVM(title: defaultUseGPSCellTitle, caption: defaultUseGPSCellCaption)
        }
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
}

// MARK: search related
extension WeatherSearchVM {
    func queueSearch(_ req: WeatherSearchRequest, completionHandler: @escaping (Result<WeatherForecast, WeatherServiceError>)->Void) {
        weatheService.searchBy(query: req) { result in
            completionHandler(result)
        }
    }
}

// MARK: cache related
extension WeatherSearchVM {
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
    
    func saveRecent(_ req: WeatherSearchRequest) {
        // cache search result
        guard let cacheItem = WeatherSearchCacheUtil().toWeatherServiceCacheItem(req) else { return }
        let _  = self.searchCache.enqueue(listName: .searchCacheList, element: cacheItem)
        self.updateSectionList()
    }
}

// MARK: location service related
extension WeatherSearchVM {
    
    func updateLocation(_ location: CLLocation, completionHandler: @escaping (Result<Bool, Error>)->Void) {
        // update and refresh table
        self.location = location
        updateSectionList()
        completionHandler(.success(true))
    }
    
    func startLocationService() {
        if (self.locationService.isActive() == true) {
            self.locationService.start()
        }
    }
    
    func stopLocationService() {
        self.locationService.stop()
    }
}


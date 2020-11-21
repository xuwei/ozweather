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
    private let listName = "WeatherSearch"
    var sections: [WeatherSearchSection] = []
    
    func loadRecent(_ completionHandler: (Result<Bool, Error>)->Void) {
        var sections: [WeatherSearchSection] = []
        let gpsSection = loadUseGPSSection()
        let recentSection = loadRecentSection()
        sections.append(gpsSection)
        sections.append(recentSection)
        self.sections = sections
        completionHandler(.success(true))
    }
    
    private func loadUseGPSSection()->WeatherSearchSection {
        let sectionTitle = "current location"
        let gpsLocation = UseGPSLocationCellVM(title: defaultUseGPSCellTitle, caption: defaultUseGPSCellCaption)
        return WeatherSearchSection(title: sectionTitle, cellVMList:  [gpsLocation])
    }
    
    private func loadRecentSection()->WeatherSearchSection {
        let sectionTitle = "recent"
        var result: [TableViewCellVMProtocol] = []
        if let recents = searchCache.getQueue(listName: listName) {
            // newly added on top, so recents.reversed()
            for cacheItem in recents.reversed() {
                let vm: WeatherLocationVM = WeatherLocationVM(text: cacheItem.stringify(), type: cacheItem.type)
                result.append(vm)
            }
        }
        
        let section = WeatherSearchSection(title: sectionTitle, cellVMList: result)
        return section
    }
    
    func queueSearch(_ query: String, completionHandler: @escaping (Result<WeatherForecast, WeatherServiceError>)->Void) {
        let searchReqUtil = WeatherSearchRequestUtil()
        guard searchReqUtil.validCharacters(query) else { completionHandler(.failure(.invalidParam)); return }
        let searchReqType = searchReqUtil.typeOfRequest(query)
        var req = WeatherSearchRequest(city: "", type: .city)
        switch searchReqType {
        case .city:
            req = WeatherSearchRequest(city: query, type: .city)
            break
        case .zipCode:
            req = WeatherSearchRequest(zip: query, type: .zipCode)
            break
        default:
            break
        }
        
        weatheService.searchBy(query: req) { result in
            completionHandler(result)
        }
    }
}


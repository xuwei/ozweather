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
    
    var listName: SearchCacheListName = .searchCacheList
    let title = ScreenName.search.rawValue
    // use real service by default, unless we overriden with mock for dev/test purpose
    private var weatheService: WeatherServiceProtocol = OpenWeatherAPI.shared
    private var searchCache: WeatherSearchCacheManagerProtocol = WeatherSearchCache.shared
    private var locationService: WLocationServiceProtocol = WLocationService.shared
    private let defaultUseGPSCellTitle = "Use my current location"
    private let defaultUseGPSCellCaption = "requires permission to detect location"
    var sections: [WeatherSearchSection] = []
    var location: CLLocationCoordinate2D?
    
    // for dependency injection
    convenience init(searchCache: WeatherSearchCacheManagerProtocol, weatheService: WeatherServiceProtocol, locationService: WLocationServiceProtocol) {
        self.init()
        self.searchCache = searchCache
        self.weatheService = weatheService
        self.locationService = locationService
    }
    
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
            let stringifyCoord = StringifyUtil.shared.stringifyCoord(latitude: location.latitude, longitude: location.longitude)
            gpsLocation = UseGPSLocationCellVM(title: defaultUseGPSCellTitle, caption: stringifyCoord)
        } else {
            gpsLocation = UseGPSLocationCellVM(title: defaultUseGPSCellTitle, caption: defaultUseGPSCellCaption)
        }
        return WeatherSearchSection(title: sectionTitle, cellVMList:  [gpsLocation])
    }
    
    private func loadRecentSection()->WeatherSearchSection {
        let sectionTitle = "most recent"
        var result: [TableViewCellVMProtocol] = []
        if let recents = searchCache.getQueue(listName: listName) {
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
    
    func toSearchRequest(_ text: String)->WeatherSearchRequest? {
        // validate text input and transform to request object
        let searchReqUtil = WeatherSearchRequestUtil()
        let reqType = searchReqUtil.typeOfRequest(text)
        switch reqType {
        case .city:
            return WeatherSearchRequest(city: text, type: .city)
        case .zipCode:
            return WeatherSearchRequest(zip: text, type: .zipCode)
        default:
            return nil
        }
    }
    
    func search(_ req: WeatherSearchRequest, completionHandler: @escaping (Result<WeatherForecast, WeatherServiceError>)->Void) {
        
        if validateSearchRequest(req) != true { completionHandler(.failure(.invalidParamFormat)); return }
        // query for forecast
        weatheService.searchBy(query: req) { result in
            completionHandler(result)
        }
    }
    
    // restrict request formats for queueSearch
    private func validateSearchRequest(_ req: WeatherSearchRequest)->Bool {
        switch req.type {
        case .city, .zipCode, .gpsCoord:
            return true
        default:
            return false
        }
    }
    
}

// MARK: cache related
extension WeatherSearchVM {
    func loadRecent(_ completionHandler: @escaping ()->Void) {
        self.updateSectionList()
        completionHandler()
    }
    
    func removeRecent(_ vm: WeatherLocationCellVM) {
        // remove from searchCache
        guard let cacheItem = WeatherSearchCacheUtil().toWeatherServiceCacheItem(vm) else { return }
        let _ = self.searchCache.clear(listName: listName,item: cacheItem)
        self.updateSectionList()
    }
    
    func saveRecent(_ req: WeatherSearchRequest) {
        // cache search result
        guard let cacheItem = WeatherSearchCacheUtil().toWeatherServiceCacheItem(req) else { return }
        let _  = self.searchCache.enqueue(listName: listName, element: cacheItem)
        self.updateSectionList()
    }
    
    func clearRecent(_ completionHandler: @escaping ()->Void) {
        self.searchCache.clearList(listName: listName)
        self.updateSectionList()
        completionHandler()
    }
}

// MARK: location service related
extension WeatherSearchVM {
    
    func updateLocation(_ location: CLLocation, completionHandler: @escaping (Result<Bool, Error>)->Void) {
        // update and refresh table
        self.location = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
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
    
    func isLocationServiceActive()->Bool {
        return self.locationService.isActive()
    }
}


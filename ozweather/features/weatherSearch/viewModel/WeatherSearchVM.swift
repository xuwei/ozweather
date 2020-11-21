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

protocol WeatherSearchVMDelegate {
    func updateTable()
}

class WeatherSearchVM {
    
    let searchCache: WeatherSearchCacheManagerProtocol = WeatherSearchCacheMock.shared
    
    let title = ScreenName.search.rawValue
    let listName = "WeatherSearch"
    var section: [WeatherSearchSection] = []
    var delegate: WeatherSearchVMDelegate?
    
    func loadRecent() {
        guard let delegate = self.delegate else { return }
        var sections: [WeatherSearchSection] = []
        let gpsSection = loadUseGPSSection()
        let recentSection = loadRecentSection()
        sections.append(gpsSection)
        sections.append(recentSection)
        delegate.updateTable()
    }
    
    private func loadUseGPSSection()->WeatherSearchSection {
        let gpsLocation = UseGPSLocationCellVM()
        return WeatherSearchSection(title: "current location", cellVMList:  [gpsLocation])
    }
    
    private func loadRecentSection()->WeatherSearchSection {
        var result: [TableViewCellVMProtocol] = []
        if let recents = searchCache.getQueue(listName: listName) {
            // newly added on top, so recents.reversed()
            for cacheItem in recents.reversed() {
                let vm: WeatherLocationVM = WeatherLocationVM(text: cacheItem.stringify(), type: cacheItem.type)
                result.append(vm)
            }
        }
        
        let section = WeatherSearchSection(title: "recent", cellVMList: result)
        return section
    }
    
    func queueSearch(_ query: String) {
        
    }
}

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
    
    let defaultUseGPSCellTitle = "Use my current location"
    let defaultUseGPSCellCaption = "requires permission to detect location"
    let listName = "WeatherSearch"
    var sections: [WeatherSearchSection] = []
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
    
    func queueSearch(_ query: String) {
        
    }
}

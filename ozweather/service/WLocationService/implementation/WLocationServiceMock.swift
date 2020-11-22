//
//  WLocationServiceMock.swift
//  ozweather
//
//  Created by Xuwei Liang on 22/11/20.
//

import Foundation
import CoreLocation

class WLocationServiceMock: NSObject, WLocationServiceProtocol {
    
    func start() {
        let currentLocation = CLLocation(latitude: -30.0, longitude: 30.0)
        NotificationUtil.shared.notify(eventName: .locationUpdate, userInfokey: .currentLocation, object: currentLocation)
    }
    
    func stop() {
        return
    }
    
    func isActive() -> Bool {
        return true
    }
}

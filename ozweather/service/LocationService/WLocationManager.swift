//
//  LocationManager.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import Foundation
import CoreLocation

protocol WLocationManagerDelegate {
    func currentCoord(coord: CLLocationCoordinate2D)
}

class WLocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = WLocationManager()
    let location = CLLocationManager()
    var delegate: WLocationManagerDelegate? = nil
    private override init() { }
    
    func start() {
        
    }
    
    func stop() {
        
    }
}


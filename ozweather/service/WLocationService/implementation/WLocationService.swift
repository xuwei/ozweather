//
//  LocationManager.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import Foundation
import CoreLocation

class WLocationService: NSObject, WLocationServiceProtocol {
    static let shared = WLocationService()
    let locationManager = CLLocationManager()
    // update around every 500 metres, since it's weather forecast, no need to update too frequently
    let distanceFilter = 500.0
    var currentLocation: CLLocation?

    private override init() {
        super.init()
        self.setupLocationManager()
    }
    
    private func setupLocationManager() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = self.distanceFilter
        self.locationManager.delegate = self
        self.locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    func start() {
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stop() {
        self.locationManager.stopUpdatingLocation()
        self.locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func isActive()->Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                return false
            }
        }
        return false
    }
    
    
}

extension WLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // get current location, last location from the callback list
        guard let last = locations.last else { return }
        self.currentLocation = last
        // notify
        NotificationUtil.shared.notify(eventName: .locationUpdate, userInfokey: .currentLocation, object: last)
        let stringifyLocation = StringifyUtil.shared.stringifyCoord(latitude: last.coordinate.latitude, longitude: last.coordinate.longitude)
        BasicLogger.shared.log(stringifyLocation)
    }
}


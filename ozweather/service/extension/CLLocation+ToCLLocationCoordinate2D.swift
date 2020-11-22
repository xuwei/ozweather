//
//  CLLocation.swift
//  ozweather
//
//  Created by Xuwei Liang on 23/11/20.
//

import CoreLocation

extension CLLocation {
    func toCLLocationCoordinate2D()->CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }
}

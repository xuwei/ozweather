//
//  CLLocation+Stringify.swift
//  ozweather
//
//  Created by Xuwei Liang on 22/11/20.
//

import CoreLocation

extension CLLocationCoordinate2D {
    func stringify()->String {
        return String("lat:\(self.latitude),lon:\(self.longitude)")
    }
}

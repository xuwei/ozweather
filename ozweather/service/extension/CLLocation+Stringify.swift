//
//  CLLocation+Stringify.swift
//  ozweather
//
//  Created by Xuwei Liang on 22/11/20.
//

import CoreLocation

extension CLLocation {
    func stringify()->String {
        return String("lat:\(self.coordinate.latitude),lon:\(self.coordinate.longitude)")
    }
}

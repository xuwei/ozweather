//
//  WeatherLocationVM.swift
//  ozweather
//
//  Created by Xuwei Liang on 21/11/20.
//

import Foundation

struct WeatherLocationVM: TableViewCellVMProtocol {
    let identifier = WeatherLocationCell.identifier
    let text: String
    let type: WeatherSearchRequestType
}

//
//  WeatherForecastCellVM.swift
//  ozweather
//
//  Created by Xuwei Liang on 23/11/20.
//
import Foundation

struct WeatherForecastCellVM: TableViewCellVMProtocol {
    var identifier: String
    let location: String
    let coordString: String
    let weatherDescription: String
    let iconUrl: String
    let temperature: Double
    let country: String
}

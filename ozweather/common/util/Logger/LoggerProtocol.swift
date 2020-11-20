//
//  Logger.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import Foundation

protocol LoggerProtocol {
    func logError(_ err: Error)
    func log(_ str: String)
}

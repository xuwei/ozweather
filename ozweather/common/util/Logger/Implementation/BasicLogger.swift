//
//  BasicLogger.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import Foundation

class BasicLogger: LoggerProtocol {
    
    static let shared = BasicLogger()
    private init() { }
    
    func printError(_ err: Error) {
        print(err.localizedDescription)
    }
}

//
//  WLocationServiceProtocol.swift
//  ozweather
//
//  Created by Xuwei Liang on 22/11/20.
//

import Foundation

protocol WLocationServiceProtocol {
    func start()
    func stop()
    func isActive()->Bool
}

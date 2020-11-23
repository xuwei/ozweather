//
//  AppData.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import Foundation
import UIKit

enum ThemeType {
    case gumtree
}

protocol ThemeProtocol {
    var themeType: ThemeType { get }
    var primaryTextColor: UIColor { get }
    var primaryColor: UIColor { get }
    var secondaryColor: UIColor { get }
    var secondaryTextColor: UIColor { get } 
    var backgroundColor: UIColor { get }
}

class AppData {
    static let shared = AppData()
    let theme: ThemeProtocol = GumtreeTheme()
    
    private init() { }
}

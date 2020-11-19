//
//  ThemeProtocol.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//
import UIKit

enum ThemeType {
    case gumtree
}

protocol ThemeProtocol {
    var themeType: ThemeType { get }
    var primaryColor: UIColor { get }
    var secondaryColor: UIColor { get }
}

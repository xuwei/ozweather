//
//  GumtreeTheme.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import Foundation
import UIKit

struct GumtreeTheme: ThemeProtocol {
    var themeType: ThemeType { get { return .gumtree } }
    var primaryTextColor: UIColor { get { return UIColor(hexString: "#515151", alpha: 1.0) ?? UIColor.black } }
    var secondaryTextColor: UIColor { get { return UIColor(hexString: "#000000", alpha: 1.0) ?? UIColor.black } }
    var primaryColor: UIColor { get { return UIColor(hexString: "#72ef36", alpha: 1.0) ?? .systemBlue } }
    var secondaryColor: UIColor { get { return UIColor(hexString: "#f0ece6", alpha: 1.0) ?? .black } }
    var backgroundColor: UIColor { get { return UIColor(hexString: "#f0ece6", alpha: 1.0) ?? .lightGray }}
}

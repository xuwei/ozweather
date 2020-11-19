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
    var primaryColor: UIColor { get { return .red } }
    var secondaryColor: UIColor { get { return .green } }
}

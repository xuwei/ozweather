//
//  UIColor_HexToColor.swift
//  ozweather
//
//  Created by Xuwei Liang on 19/11/20.
//

import UIKit

extension UIColor {
    convenience init?(hexString: String, alpha: CGFloat) {
        guard alpha >= 0.0 && alpha <= 1.0 else { return nil }
        guard hexString.count == 7 else { return nil }
        guard hexString.hasPrefix("#") else { return nil }
        let hexStr = hexString.uppercased()
        let hex = String(hexStr.suffix(from: hexStr.index(hexStr.startIndex, offsetBy: 1)))
        let currentHexSet = CharacterSet(charactersIn: hex)
        let hexCharacterSet = CharacterSet(charactersIn: "ABCDEF1234567890")
        guard hexCharacterSet.isSuperset(of: currentHexSet) == true else { return nil }
        var color: UInt32 = 0
        let scanner = Scanner(string: hexStr)
        scanner.scanLocation = 1
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        
        // shift and mask to extract the value from hex format and parse it into Int
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        // convert into RGB format
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func toHex()->String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &alpha)
        let rgb: Int = (Int) (r*255) << 16 | (Int) (g*255) << 8 | (Int) (b*255)
        return String(format: "#%06x", rgb)
    }
}

//
//  UIColor_HexToColor_Tests.swift
//  ozweatherTests
//
//  Created by Xuwei Liang on 19/11/20.
//

import XCTest
import UIKit
@testable import ozweather

class UIColor_HexToColor_Tests: XCTestCase {

    func testInitColorByHex() {
        let color = UIColor(hexString: "#ff0000", alpha: 1.0)
        XCTAssertFalse(color == UIColor.red.withAlphaComponent(0.5))
        XCTAssertTrue(color == UIColor.red.withAlphaComponent(1.0))
    }
    
    func testInitColorByInvalidArg() {
        let color1 = UIColor(hexString: "ff0000", alpha: 1.0)
        XCTAssertNil(color1)
        
        let color2 = UIColor(hexString: "#ff000", alpha: 1.0)
        XCTAssertNil(color2)
        
        let color3 = UIColor(hexString: "#ff000z", alpha: 1.0)
        XCTAssertNil(color3)
        
        let color4 = UIColor(hexString: "#ff#$99", alpha: 1.0)
        XCTAssertNil(color4)
        
        let color5 = UIColor(hexString: "#ff0000", alpha: 1.1)
        XCTAssertNil(color5)
        
        let color6 = UIColor(hexString: "#ff0000", alpha: -0.01)
        XCTAssertNil(color6)
    }
    
    func testColorToHexString() {
        let color1 = UIColor.red.withAlphaComponent(1.0)
        let result1 = color1.toHex()
        XCTAssertTrue(result1 == "#ff0000")
        
        let color2 = UIColor.red.withAlphaComponent(0.0)
        let result2 = color2.toHex()
        XCTAssertTrue(result2 == "#ff0000")
    }
}

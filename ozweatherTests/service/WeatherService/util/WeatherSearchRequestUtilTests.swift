//
//  WeatherSearchRequestUtilTests.swift
//  ozweatherTests
//
//  Created by Xuwei Liang on 22/11/20.
//

import XCTest
@testable import ozweather

class WeatherSearchRequestUtilTests: XCTestCase {

    let reqUtil = WeatherSearchRequestUtil()
    
    func testValidCharactersPositive() {
        let result1 = reqUtil.validCharacters("Atlanta")
        XCTAssertTrue(result1)
        let result2 = reqUtil.validCharacters("30301")
        XCTAssertTrue(result2)
        let result3 = reqUtil.validCharacters("Sydney 2000")
        XCTAssertTrue(result3)
        let result4 = reqUtil.validCharacters("Hong Kong Sydney 2000")
        XCTAssertTrue(result4)
        let result5 = reqUtil.validCharacters("New York")
        XCTAssertTrue(result5)
    }
    
    func testValidCharactersNegative() {
        let result1 = reqUtil.validCharacters("!")
        XCTAssertFalse(result1)
        let result2 = reqUtil.validCharacters("2000.1")
        XCTAssertFalse(result2)
        let result3 = reqUtil.validCharacters("New-York")
        XCTAssertFalse(result3)
        let result4 = reqUtil.validCharacters("悉尼")
        XCTAssertFalse(result4)
        let result5 = reqUtil.validCharacters("1000-1")
        XCTAssertFalse(result5)
    }
    
    func testTypeOfRequestCity() {
        let type1 = reqUtil.typeOfRequest("Atlanta")
        XCTAssertTrue(type1 == .city)
        let type2 = reqUtil.typeOfRequest("Sydney")
        XCTAssertTrue(type2 == .city)
        let type3 = reqUtil.typeOfRequest("New York")
        XCTAssertTrue(type3 == .city)
        let type4 = reqUtil.typeOfRequest("30301")
        XCTAssertFalse(type4 == .city)
        let type5 = reqUtil.typeOfRequest("Sydney 2000")
        XCTAssertFalse(type5 == .city)
        let type6 = reqUtil.typeOfRequest("-30.0, 30.0")
        XCTAssertFalse(type6 == .city)
    }
    
    func testTypeOfRequestZipcode() {
        let type1 = reqUtil.typeOfRequest("30301")
        XCTAssertTrue(type1 == .zipCode)
        let type2 = reqUtil.typeOfRequest("10001 ")
        XCTAssertTrue(type2 == .zipCode)
        let type3 = reqUtil.typeOfRequest("1000 1")
        XCTAssertFalse(type3 == .zipCode)
        let type4 = reqUtil.typeOfRequest("30301 Atlanta")
        XCTAssertFalse(type4 == .zipCode)
        let type5 = reqUtil.typeOfRequest("30301-Atlanta")
        XCTAssertFalse(type5 == .zipCode)
        let type6 = reqUtil.typeOfRequest("-30.0, 30.0")
        XCTAssertFalse(type6 == .zipCode)
    }
    
    func testTypeOfRequestUnknown() {
        let type1 = reqUtil.typeOfRequest("john@gmail.com")
        XCTAssertTrue(type1 == .unknown)
        let type2 = reqUtil.typeOfRequest("30301 Atlanta")
        XCTAssertTrue(type2 == .unknown)
        let type3 = reqUtil.typeOfRequest("-30.0,30.0")
        XCTAssertTrue(type3 == .unknown)
        let type4 = reqUtil.typeOfRequest("Sydney2000")
        XCTAssertTrue(type4 == .unknown)
        let type5 = reqUtil.typeOfRequest("#1000")
        XCTAssertTrue(type5 == .unknown)
        let type6 = reqUtil.typeOfRequest("@Hk")
        XCTAssertTrue(type6 == .unknown)
    }
}

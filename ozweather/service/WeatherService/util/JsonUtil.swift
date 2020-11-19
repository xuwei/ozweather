//
//  JsonUtil.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import Foundation

class JsonUtil {
    static let shared = JsonUtil()
    private init() { }
    
    func printAsJson(data: Data?) {
        guard let data = data else { print("printAsJson - data is nil"); return }
        do {
            if let json = try JSONSerialization.jsonObject(with:data) as? [String: Any] {
                print(json.description)
            }
            
        } catch let err {
            print(err)
        }
    }
}



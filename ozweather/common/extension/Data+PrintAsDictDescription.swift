//
//  Data_Print.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import Foundation

extension Data {
    
    // utility method to convert data to dictionary, then print
    func printAsDictDescription() {
        do {
            if let json = try JSONSerialization.jsonObject(with:self) as? [String: Any] {
                print(json.description)
            }
            
        } catch let err {
            print(err)
        }
    }
}

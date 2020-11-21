//
//  UserDefaults_SaveCustomObject.swift
//  ozweather
//
//  Created by Xuwei Liang on 20/11/20.
//

import Foundation

// extending methods to simplify storing/retrieving of codable objects to UserDefaults
extension UserDefaults {
    
    public func setCustomObject<T: Encodable>(_ object: T?, forKey key:String) throws {
        guard let object = object else { removeObject(forKey: key); return }
        do {
            let encoded = try PropertyListEncoder().encode(object)
            set(encoded, forKey: key)
        } catch let error {
            throw error
        }
    }
    
    public func customObjectArray<T: Decodable>(forKey key: String) -> T? {
        guard let data = self.data(forKey: key) else { return nil }
        do {
            return try PropertyListDecoder().decode(T.self, from: data)
        } catch {
            return nil
        }
    }
}

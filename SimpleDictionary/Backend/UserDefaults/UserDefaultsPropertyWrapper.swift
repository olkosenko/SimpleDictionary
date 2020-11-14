//
//  UserDefaultsPropertyWrapper.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-14.
//

import Foundation

// Source https://www.avanderlee.com/swift/property-wrappers/

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

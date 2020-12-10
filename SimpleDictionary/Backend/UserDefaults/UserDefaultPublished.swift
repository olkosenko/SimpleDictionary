//
//  UserDefaultPublished.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-30.
//

import Foundation
import Combine

@propertyWrapper
struct UserDefaultPublished<Value: Codable> {
    
    let key: String
    let container: UserDefaults
    
    let publisher: CurrentValueSubject<Value, Never>

    var projectedValue: CurrentValueSubject<Value, Never> { return publisher }
    
    var wrappedValue: Value {
        get {
            publisher.value
        }
        set {
            publisher.send(newValue)
            container.setValue(try? PropertyListEncoder.propertyListEncoder.encode(newValue),
                               forKey: key)
        }
    }
    
    init(_ key: String, defaultValue: Value, container: UserDefaults = .standard) {
        self.key = key
        self.container = container
        
        var value = defaultValue
        if let data = container.value(forKey: key) as? Data {
            let optionalValue = try? PropertyListDecoder().decode(Value.self, from: data)
            value = optionalValue ?? defaultValue
        }
        
        publisher = .init(value)
    }
}

fileprivate extension PropertyListEncoder {
    static let propertyListEncoder = PropertyListEncoder()
}

//
//  AppUserDefaults.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-14.
//

import Foundation
import ComposableArchitecture

extension UserDefaults {
    
    @objc var isDictionaryDateShown: Bool {
        get {
            return bool(forKey: "isDictionaryDateShown")
        }
        set {
            set(newValue, forKey: "isDictionaryDateShown")
        }
    }
    
    static func effectFor<Value>(_ keyPath: KeyPath<UserDefaults, Value>) -> Effect<Value, Never> {
        UserDefaults.standard.publisher(for: keyPath).eraseToEffect()
    }
}


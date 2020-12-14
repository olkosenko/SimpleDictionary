//
//  Collection.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-28.
//

import Foundation

extension RangeReplaceableCollection {
    var isNotEmpty: Bool {
        !self.isEmpty
    }
}

extension MutableCollection {
    
    subscript(safe index: Index) -> Element? {
        get {
            return self.indices.contains(index) ? self[index] : nil
        }
        set {
            guard let newValue = newValue, self.indices.contains(index) else { return }
            self[index] = newValue
        }
    }
    
}

//
//  String.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-08.
//

import Foundation

extension String {
    var isBlank: Bool {
        allSatisfy { $0.isWhitespace }
    }
    
    func capitalizeFirst() -> String {
        self.prefix(1).capitalized + dropFirst()
    }
}

//
//  DictionarySection.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-04.
//

import Foundation

enum DictionaryTab: CaseIterable, Identifiable {
    case oxford
    case merriamwebster
    case urban
    
    var id: String {
        switch self {
        case .oxford:
            return "Oxford"
        case .merriamwebster:
            return "Merriam-Webster"
        case .urban:
            return "Urban"
        }
    }
}

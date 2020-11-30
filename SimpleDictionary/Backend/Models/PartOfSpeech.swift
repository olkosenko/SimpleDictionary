//
//  PartOfSpeech.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-20.
//

import Foundation

enum PartOfSpeech: String, CaseIterable, Identifiable, Equatable {
    
    case noun
    case verb
    case pronoun
    case adverb
    case adjective
    case preposition
    case conjunction
    case interjection
    
    var id: String { self.rawValue }
}

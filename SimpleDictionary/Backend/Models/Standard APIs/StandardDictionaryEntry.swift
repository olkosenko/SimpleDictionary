//
//  StandardDictionaryEntry.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-12.
//

import Foundation

struct StandardDictionaryEntry {
    let word: String
    let phoneticSpelling: String?
    // sound
    let definitions: [String]
    let synonyms: [String]
    let antonyms: [String]
    let examples: [String]
    let etymologies: [String]
}

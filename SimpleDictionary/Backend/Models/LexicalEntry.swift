//
//  LexicalEntry.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import Foundation

struct LexicalEntry: Decodable, Identifiable {
    
    let id = UUID()
    let entries: [Entry]?
}

let staticLexicalEntry = LexicalEntry(entries: [staticEntry])

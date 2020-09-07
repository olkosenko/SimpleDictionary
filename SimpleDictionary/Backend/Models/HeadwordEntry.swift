//
//  HeadwordEntry.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import Foundation

struct HeadwordEntry: Decodable {
    
    /// A grouping of various senses in a specific language, and a lexical category that relates to a word.
    let lexicalEntries: [LexicalEntry]?
}

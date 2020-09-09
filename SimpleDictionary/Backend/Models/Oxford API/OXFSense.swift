//
//  Sense.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import Foundation

struct OXFSense: Decodable {
    
    /// A list of statements of the exact meaning of a word.
    let definitions: [String]?
    
    let examples: [OXFExamplesList]?
}

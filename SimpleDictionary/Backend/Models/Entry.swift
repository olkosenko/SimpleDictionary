//
//  Entry.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import Foundation

struct Entry: Decodable {
    /// The origin of the word and the way in which its meaning has changed throughout history.
    let etymologies: [String]?
    
    /// Complete list of senses.
    let senses: [Sense]?
}

let staticEntry = Entry(etymologies: nil, senses: [staticSense])

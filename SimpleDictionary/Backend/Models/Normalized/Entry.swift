//
//  Entry.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-08.
//

import Foundation

struct Entry: Identifiable {
    let id = UUID()
    let definitions: [String]
    let examples: [String]
}

let staticEntries = [
    Entry(definitions: ["Used when meeting or greeting someone."], examples: staticExamples)
]

private let staticExamples = [
    "Hello, Paul. I haven't seen you for ages.",
    "I know her vaguely - we've exchanged hellos a few times.",
    "I just thought I'd call by and say hello.",
    "And a big hello (= welcome) to all the parents who've come to see the show."
    ]

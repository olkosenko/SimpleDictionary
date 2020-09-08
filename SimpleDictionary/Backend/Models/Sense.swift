//
//  Sense.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import Foundation

struct Sense: Decodable {
    
    /// A list of statements of the exact meaning of a word.
    let definitions: [String]?
    
    let examples: [ExamplesList]?
}

private let staticDefinitions = [
    "used when meeting or greeting someone"
    ]

private let staticExamples = [
    ExamplesList(text: "Hello, Paul. I haven't seen you for ages."),
    ExamplesList(text: "I know her vaguely - we've exchanged hellos a few times."),
    ExamplesList(text: "I just thought I'd call by and say hello."),
    ExamplesList(text: "And a big hello (= welcome) to all the parents who've come to see the show.")
    ]

let staticSense = Sense(definitions: staticDefinitions, examples: staticExamples)

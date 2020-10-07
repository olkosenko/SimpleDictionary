//
//  RetrieveEntry.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import Foundation

struct OXFRetrieveEntry: Decodable {
    /// A list of entries and all the data related to them.
    let results: [OXFHeadwordEntry]?
}

extension OXFRetrieveEntry: EntryConvertable {
    func convert() -> [Entry] {
        guard let result = self.results else { return [] }
        let mapped = result
            .compactMap { $0.lexicalEntries }
            .flatMap { $0 }
            .compactMap { $0.entries }
            .flatMap { $0 }
            .compactMap { $0.senses }
            .flatMap { $0 }
            .compactMap { sense -> Entry? in
                if let definitions = sense.definitions {
                    let examples = sense.examples?.map { $0.text }
                    return Entry(definitions: definitions, examples: examples ?? [])
                }
                return nil
            }
        
        return mapped
    }
}

//
//  OxfordEntry.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import Foundation

struct OxfordEntry: Decodable {
    /// A list of entries and all the data related to them.
    let results: [OXFHeadwordEntry]?
}

struct OXFHeadwordEntry: Decodable {
    /// A grouping of various senses in a specific language, and a lexical category that relates to a word.
    let lexicalEntries: [OXFLexicalEntry]?
}

struct OXFLexicalEntry: Decodable {

    let entries: [OXFEntry]?
    let lexicalCategory: PartOfSpeech
    
    enum CodingKeys: String, CodingKey {
        case entries
        case lexicalCategory
    }
    
    enum LexicalCategoryCodingKeys: String, CodingKey {
        case text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if container.contains(.entries) {
            entries = try container.decode([OXFEntry].self, forKey: .entries)
        } else {
            entries = nil
        }
        
        if container.contains(.lexicalCategory) {
            let lexicalCategoryContainer = try container.nestedContainer(keyedBy: LexicalCategoryCodingKeys.self,
                                                                         forKey: .lexicalCategory)
            
            let lexicalCategoryText = try lexicalCategoryContainer.decode(String.self, forKey: .text)
            lexicalCategory = PartOfSpeech(rawValue: lexicalCategoryText.lowercased()) ?? .noun
        } else {
            lexicalCategory = .noun
        }
    }
}

struct OXFEntry: Decodable {
    /// The origin of the word and the way in which its meaning has changed throughout history.
    let etymologies: [String]?
    
    /// Complete list of senses.
    let senses: [OXFSense]?
    
    let pronunciations: [OXFPronunciation]?
}

struct OXFPronunciation: Decodable {
    let audioFile: URL?
    let phoneticSpelling: String?
    
    enum CodingKeys: String, CodingKey {
        case audioFile
        case phoneticSpelling
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.phoneticSpelling) {
            phoneticSpelling = try container.decode(String.self, forKey: .phoneticSpelling)
        } else {
            phoneticSpelling = nil
        }
        
        if container.contains(.audioFile) {
            let stringURL = try container.decode(String.self, forKey: .audioFile)
            audioFile = URL(string: stringURL)
        } else {
            audioFile = nil
        }
    }
}

struct OXFSense: Decodable {
    /// A list of statements of the exact meaning of a word.
    let definitions: [String]?
    let examples: [OXFContainerWithText]?
    let synonyms: [OXFContainerWithText]?
}

struct OXFContainerWithText: Decodable {
    let text: String
}

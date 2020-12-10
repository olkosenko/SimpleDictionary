//
//  StandardDictionaryEntry.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-12.
//

import Foundation

struct StandardDictionaryEntry: Equatable {
    let phoneticSpelling: String?
    let soundURL: URL?
    let entries: [Entry]
    let etymologies: [String]
    
    static let standardDictionaryTestEntry = StandardDictionaryEntry(
        entries: Array(repeating: Entry.testEntry, count: 3),
        etymologies: Array(repeating: "An apparatus, system, or process for transmission of sound or speech to a distant point, especially by an electric device.", count: 5)
        )
    
    struct Entry: Equatable, Hashable {
        let definitions: [String]
        let synonyms: [String]
        let partOfSpeech: PartOfSpeech
        let examples: [String]
        
        static let testEntry = Entry(
            definitions: Array(repeating: "An apparatus, system, or process for transmission of sound or speech to a distant point, especially by an electric device.", count: 5),
            synonyms: ["Good", "Bad", "Awesome", "Cool"],
            partOfSpeech: .noun,
            examples: Array(repeating: "An apparatus, system, or process for transmission of sound or speech to a distant point, especially by an electric device.", count: 5))
    }
    
    init?(oxfordEntry: OxfordEntry) {
        guard let results = oxfordEntry.results else { return nil }
        let lexicalEntries = results.compactMap { $0.lexicalEntries }.flatMap { $0 }
        guard lexicalEntries.isNotEmpty else { return nil }
        
        var entries = [Entry]()
        var etymologies = [String]()
        var soundURL: URL? = nil
        var phoneticSpelling: String? = nil
        
        lexicalEntries.forEach { lexicalEntry in
            guard let oxfEntries = lexicalEntry.entries else { return }
            
            let partOfSpeech = lexicalEntry.lexicalCategory
            var entryDefinitions = [String]()
            var entryExamples = [String]()
            var entrySynonyms = [String]()
            
            oxfEntries.forEach { oxfEntry in
                if let oxfEtymologies = oxfEntry.etymologies {
                    etymologies.append(contentsOf: oxfEtymologies)
                }
                
                if let oxfSenses = oxfEntry.senses {
                    oxfSenses.forEach { oxfSense in
                        if let oxfDefs = oxfSense.definitions {
                            entryDefinitions.append(contentsOf: oxfDefs)
                        }
                        
                        if let oxfMarkers = oxfSense.crossReferenceMarkers {
                            entryDefinitions.append(contentsOf: oxfMarkers)
                        }
                        
                        if let oxfExmpls = oxfSense.examples {
                            oxfExmpls.forEach { entryExamples.append($0.text) }
                        }
                        
                        if let oxfSynonyms = oxfSense.synonyms {
                            oxfSynonyms.forEach { entrySynonyms.append($0.text) }
                        }
                    }
                }
                
                if let pronunciations = oxfEntry.pronunciations {
                    
                    if phoneticSpelling == nil,
                       let first = pronunciations.first,
                       let unwrappedSpelling = first.phoneticSpelling {
                        
                        phoneticSpelling = unwrappedSpelling
                    }
                    
                    if soundURL == nil {
                        soundURL = pronunciations.first(where: { p in p.audioFile != nil })?.audioFile
                    }
                    
                }
                
            }
            
            entrySynonyms = Array(Set(entrySynonyms))
            if entrySynonyms.count > 20 {
                entrySynonyms = Array(entrySynonyms[0...19])
            }
            
            if entryDefinitions.isNotEmpty {
                let entry = Entry(definitions: entryDefinitions,
                                  synonyms: entrySynonyms,
                                  partOfSpeech: partOfSpeech,
                                  examples: entryExamples)
                
                entries.append(entry)
            }
        }
        
        if entries.isEmpty { return nil }
        self.entries = entries
        self.etymologies = etymologies
        self.phoneticSpelling = phoneticSpelling
        self.soundURL = soundURL
    }
    
    init(entries: [Entry], etymologies: [String]) {
        self.entries = entries
        self.etymologies = etymologies
        self.phoneticSpelling = nil
        self.soundURL = nil
    }
}

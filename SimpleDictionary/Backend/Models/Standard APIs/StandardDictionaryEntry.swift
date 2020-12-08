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
    
    struct Entry: Equatable {
        let definitions: [String]
        let synonyms: [String]
        let partOfSpeech: PartOfSpeech
        let examples: [String]
    }
    
    init?(oxfordEntry: OxfordEntry) {
        guard let results = oxfordEntry.results?.first,
              let lexicalEntries = results.lexicalEntries
        else { return nil }
        
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
}

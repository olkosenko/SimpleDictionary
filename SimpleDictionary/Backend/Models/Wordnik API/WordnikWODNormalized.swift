//
//  WordnikWODNormalized.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-29.
//

import Foundation

struct WordnikWODNormalized: Equatable, Hashable {
    let title: String
    let date: Date
    let partOfSpeech: PartOfSpeech
    let definition: String
    
    init?(wordnikWod: WordnikWOD) {
        guard let title = wordnikWod.word,
              let stringDate = wordnikWod.publishDate,
              let date = DateFormatter.isoDateFormatter.date(from: stringDate),
              let definitions = wordnikWod.definitions,
              let firstDefinition = definitions.first,
              let definition = firstDefinition.text else {
            return nil
        }
        self.title = title
        self.date = date
        self.partOfSpeech = PartOfSpeech(rawValue: firstDefinition.partOfSpeech ?? "") ?? .noun
        self.definition = definition
    }
    
    init?(word: Word) {
        guard let title = word.title,
              let date = word.date,
              let definition = word.normalizedDefinitions.first,
              let definitionTitle = definition.title else {
            return nil
        }
        
        self.title = title
        self.date = date
        self.partOfSpeech = definition.normalizedPartOfSpeech
        self.definition = definitionTitle
    }
}

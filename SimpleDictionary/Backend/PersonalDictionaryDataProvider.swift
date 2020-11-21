//
//  PersonalDictionaryDataProvider.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-20.
//

import Foundation
import Combine
import ComposableArchitecture

class PersonalDictionaryDataProvider {
    
    private let apiService: APIService
    private let coreDataService: CoreDataService
    
    init(apiService: APIService, coreDataService: CoreDataService) {
        self.apiService = apiService
        self.coreDataService = coreDataService
    }
    
    func saveWord(_ word: ManualWordCreationState) -> Effect<Word, Error> {
        var definitions = [PartOfSpeech : [String]]()
        word.definitions.forEach { definition in
            guard definition.title.isNotEmpty else { return }
            
            if definitions[definition.partOfSpeech] != nil {
                definitions[definition.partOfSpeech]!.append(definition.title)
            } else {
                definitions[definition.partOfSpeech] = [definition.title]
            }
        }
        
        return coreDataService.addWord(ofType: .casual, title: word.title, date: Date(), definitions: definitions)
    }
    
    func fetchWords() -> Effect<[Word], Error> {
        return coreDataService.fetchWords(ofType: .casual)
    }
}


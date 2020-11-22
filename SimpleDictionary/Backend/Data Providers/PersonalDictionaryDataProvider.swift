//
//  PersonalDictionaryDataProvider.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-20.
//

import Foundation
import Combine
import ComposableArchitecture
import CoreData

class PersonalDictionaryDataProvider {
    private let coreDataService: CoreDataService

    var wordsPublisher: Effect<[Word], Error> {
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(#keyPath(Word.isWOD)) = %@", "NO")
        fetchRequest.sortDescriptors = []
        
        return CoreDataPublisher(context: coreDataService.context, fetchRequest: fetchRequest)
            .publisher
            .eraseToEffect()
    }
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    func fetchWords() -> Effect<[Word], Error> {
        return coreDataService.fetchWords(ofType: .casual)
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
}


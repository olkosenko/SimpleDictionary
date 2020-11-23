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

    private lazy var coreDataPublisher: CoreDataPublisher<Word> = {
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(#keyPath(Word.isWOD)) == NO")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Word.date, ascending: false)]
        return CoreDataPublisher(context: coreDataService.context, fetchRequest: fetchRequest)
    }()
    
    var wordsPublisher: Effect<[Word], Error> {
        coreDataPublisher
            .publisher
            .eraseToEffect()
    }
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    func fetchWords() -> Effect<[Word], Error> {
        return coreDataService.fetchWords(ofType: .casual)
    }
    
    func saveWord(title: String, definitions: [PartOfSpeech : [String]]) -> Effect<Word, Error> {
        return coreDataService.addWord(ofType: .casual, title: title, date: Date(), definitions: definitions)
    }
    
    func deleteWords(_ words: [Word]) {
        coreDataService.deleteWords(words)
    }
    
    func saveChanges() {
        coreDataService.context.saveIfNeeded()
    }
}


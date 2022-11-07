//
//  GameDataProvider.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-14.
//

import Combine
import ComposableArchitecture
import CoreData

class GameDataProvider {
    
    private let coreDataService: CoreDataService
    
    private lazy var coreDataWordsPublisher: CoreDataPublisher<Word> = {
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Word.date, ascending: false)]
        return CoreDataPublisher(context: coreDataService.context, fetchRequest: fetchRequest)
    }()
    
    var wordsPublisher: Effect<[Word], Never> {
        coreDataWordsPublisher
            .publisher
            .map { words in
                words.filter { !$0.normalizedDefinitions.isEmpty }
            }
            .replaceError(with: [])
            .eraseToEffect()
    }
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
}

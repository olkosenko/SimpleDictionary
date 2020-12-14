//
//  GameDataProvider.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-14.
//

import Foundation
import Combine
import CoreData

class GameDataProvider {
    
    private let coreDataService: CoreDataService
    
    private lazy var coreDataWordsPublisher: CoreDataPublisher<Word> = {
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(#keyPath(Word.isWOD)) == NO")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Word.date, ascending: false)]
        return CoreDataPublisher(context: coreDataService.context, fetchRequest: fetchRequest)
    }()
    
    var wordsPublisher: AnyPublisher<[Word], Error> {
        coreDataWordsPublisher
            .publisher
            .eraseToAnyPublisher()
    }
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    
}

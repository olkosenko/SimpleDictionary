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

    private lazy var coreDataWordsPublisher: CoreDataPublisher<Word> = {
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(#keyPath(Word.isWOD)) == NO")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Word.date, ascending: false)]
        return CoreDataPublisher(context: coreDataService.context, fetchRequest: fetchRequest)
    }()
    
    var wordsPublisher: Effect<[Word], Error> {
        coreDataWordsPublisher
            .publisher
            .eraseToEffect()
    }
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }

    func insertWord(title: String, definitions: [PartOfSpeech : [String]]) -> Effect<Word, Error> {
        return coreDataService.addWord(ofType: .casual, title: title, date: Date(), definitions: definitions)
    }
    
    func insertWord(title: String, definitions: [Definition]) -> Effect<Word, Error> {
        return coreDataService.addWord(ofType: .casual, title: title, date: Date(), definitions: definitions)
    }
    
    func deleteWords(_ words: [Word]) {
        coreDataService.deleteWords(words)
    }
    
    func deleteDefinitions(_ definitions: [Definition]) {
        coreDataService.context.writeAsync { context in
            definitions.forEach { definition in
                context.delete(definition)
            }
        }
    }
    
    func toggleLearnStatus(for word: Word) {
        coreDataService.context.writeAsync { context in
            word.isLearned.toggle()
        }
    }
    
    func handleWordStateChanges(for word: Word, editableDefinitions: [EditableDefinition]) {
            coreDataService.context.writeAsync { context in
                
                /// Remove
                word.normalizedDefinitions.forEach { definition in
                    if editableDefinitions.first(where: { $0.id == definition.id }) == nil {
                        context.delete(definition)
                    }
                }
                
                /// Insert & Update
                editableDefinitions.forEach { definition in
                    if let foundDefinition = word.normalizedDefinitions.first(where: { $0.id == definition.id }) {
                        if definition.title.isEmpty {
                            self.deleteDefinitions([foundDefinition])
                        } else {
                            foundDefinition.title = definition.title
                            foundDefinition.normalizedPartOfSpeech = definition.partOfSpeech
                        }
                    } else if definition.title.isNotEmpty {
                        let newDefinition = self.insertNewDefinition()
                        newDefinition.id = definition.id
                        newDefinition.title = definition.title
                        newDefinition.normalizedPartOfSpeech = definition.partOfSpeech
                        word.addToDefinitions(newDefinition)
                    }
                }
            }
    }
    
    func insertNewDefinition() -> Definition {
        let newDefinition = Definition(context: coreDataService.context)
        newDefinition.id = UUID()
        newDefinition.title = ""
        newDefinition.normalizedPartOfSpeech = .noun
        return newDefinition
    }
    
    func saveChanges() -> Effect<Bool, Never> {
        Future { [weak self] promise in
            let result = self?.coreDataService.context.saveIfNeeded()
            promise(.success(result ?? false))
        }
        .eraseToEffect()
    }
}


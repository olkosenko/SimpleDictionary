//
//  CoreDataService.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-13.
//

import Foundation
import CoreData
import Combine
import ComposableArchitecture

final class CoreDataService {
    
    enum WordType {
        case casual
        case wod
    }
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    @discardableResult
    func addWord(
        ofType wordType: WordType = .casual,
        title: String,
        phoneticSpelling: String? = nil,
        date: Date = Date(),
        soundURL: URL? = nil,
        definitions: [PartOfSpeech : [String]] = [:]
    ) -> Effect<Word, Error> {
        
        wrapInEffectAndContext { context in
            let newWord = Word(context: context)
            newWord.id = UUID()
            newWord.title = title
            newWord.phoneticSpelling = phoneticSpelling
            newWord.date = date
            newWord.isWOD = wordType == .wod ? true : false
            
            definitions.forEach { partOfSpeech, defs in
                defs.forEach { def in
                    let newDefinition = Definition(context: context)
                    newDefinition.id = UUID()
                    newDefinition.title = def
                    newDefinition.partOfSpeech = partOfSpeech.rawValue
                    
                    newWord.addToDefinitions(newDefinition)
                }
            }

            return .success(newWord)
        }
        
    }
    
    @discardableResult
    func addWord(
        ofType wordType: WordType = .casual,
        title: String,
        phoneticSpelling: String? = nil,
        date: Date = Date(),
        soundURL: URL? = nil,
        definitions: [Definition]
    ) -> Effect<Word, Error> {
        
        wrapInEffectAndContext { context in
            let newWord = Word(context: context)
            newWord.id = UUID()
            newWord.title = title
            newWord.phoneticSpelling = phoneticSpelling
            newWord.date = date
            newWord.isWOD = NSNumber(value: wordType == .wod ? true : false)
            newWord.addToDefinitions(NSSet(array: definitions))
            return .success(newWord)
        }
        
    }
    
    func deleteWords(
        _ words: [Word]
    ) {
        context.writeAsync { context in
            words.forEach { word in
                context.delete(word)
            }
        }
    }
    
    func fetchWords(
        ofType wordType: WordType,
        limit: Int? = nil
    ) -> Effect<[Word], Error> {
        return wrapInEffectAndContext { context in
            Result<[Word], Error> {
                let predicate = NSPredicate(format: "\(#keyPath(Word.isWOD)) == %@",
                                            NSNumber(value: wordType == .wod ? true : false))
                let sortDescriptors = [NSSortDescriptor(keyPath: \Word.date, ascending: false)]
                
                let words = try self.context.fetchEntities(ofType: Word.self,
                                                           with: predicate,
                                                           sortDescriptors: sortDescriptors,
                                                           fetchLimit: limit)
                
                return words
            }
        }
    }
    
    private func wrapInEffectAndContext<T>(
        task: @escaping (NSManagedObjectContext) -> Result<T, Error>
    ) -> Effect<T, Error> {
        Future { [unowned self] promise in
            self.context.writeAsync { _ in
                switch task(self.context) {
                case .success(let result):
                    promise(.success(result))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToEffect()
    }
             
}

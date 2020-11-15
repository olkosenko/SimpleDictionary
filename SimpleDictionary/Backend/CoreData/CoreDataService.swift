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
    
    enum DictionaryServiceError: Error {
        case failedFetch(String)
    }
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addWord(
        ofType wordType: WordType = .casual,
        title: String,
        phoneticSpelling: String? = nil,
        date: Date = Date(),
        soundURL: URL? = nil,
        definitions: [String : [String]] = [:]
    ) -> Effect<Word, DictionaryServiceError> {
        
        wrapInEffectAndContext { context in
            let newWord = Word(context: context)
            newWord.title = title
            newWord.phoneticSpelling = phoneticSpelling
            newWord.date = date
            newWord.isWOD = wordType == .wod ? true : false
            
            definitions.forEach { partOfSpeech, defs in
                defs.forEach { def in
                    let newDefinition = Definition(context: context)
                    newDefinition.title = def
                    newDefinition.partOfSpeech = partOfSpeech
                    
                    newWord.addToDefinitions(newDefinition)
                }
            }

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
    ) -> Effect<[Word], DictionaryServiceError> {
        wrapInEffectAndContext { context in
            do {
                let predicate = NSPredicate(format: "\(#keyPath(Word.isWOD)) = %@",
                                            wordType == .casual ? "YES" : "NO")
                
                let sortDescriptors = [NSSortDescriptor(keyPath: \Word.date, ascending: true)]
                let words = try self.context.fetchEntities(ofType: Word.self,
                                                           with: predicate,
                                                           sortDescriptors: sortDescriptors,
                                                           fetchLimit: limit)
                
                return .success(words)
            }
            catch {
                return .failure(DictionaryServiceError.failedFetch(error.localizedDescription))
            }
        }
    }
    
    private func wrapInEffectAndContext<T>(
        task: @escaping (NSManagedObjectContext) -> Result<T, DictionaryServiceError>
    ) -> Effect<T, DictionaryServiceError> {
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

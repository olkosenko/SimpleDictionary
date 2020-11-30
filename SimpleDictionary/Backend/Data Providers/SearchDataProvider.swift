//
//  WODDataProvider.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-14.
//

import UIKit
import Combine
import ComposableArchitecture

class SearchDataProvider {
    
    private let apiService: APIService
    private let coreDataService: CoreDataService
    
    private let textChecker = UITextChecker()
    
    init(apiService: APIService, coreDataService: CoreDataService) {
        self.apiService = apiService
        self.coreDataService = coreDataService
    }
    
    func fetchWordSuggestions(for query: String) -> Effect<[String], Never> {
        [query].publisher
            .map { query in
                let targetText = String(query.split(separator: " ").last!)
                let range = NSRange(targetText.startIndex..<targetText.endIndex, in: targetText)
                let completions = textChecker.completions(forPartialWordRange: range, in: targetText, language: "en")
                var result = completions ?? []
                if result.isEmpty {
                    let guesses = textChecker.guesses(forWordRange: range, in: targetText, language: "en")
                    result.append(contentsOf: guesses ?? [])
                }
                result.insert(query, at: 0)
                return result
            }
            .eraseToEffect()
    }
    
    func fetchWODs() -> Effect<[WordnikWODNormalized], Error> {
        let requiredCount = 7
        var dateComponents = DateComponents()
        var requiredDates = [String : Date]()
        
        for day in 0..<requiredCount {
            dateComponents.day = -day
            let date = Date().changed(with: dateComponents)
            requiredDates[date.yearMonthDayLocal] = date /// yearMonthDay gives date in local timeZone
        }

        return coreDataService.fetchWords(ofType: .wod, limit: requiredCount)
            .replaceError(with: [])
            .flatMap { dbWords -> AnyPublisher<[WordnikWODNormalized], Error> in
                var mutableDBWords = dbWords
                
                mutableDBWords.removeAll { word in
                    requiredDates.removeValue(forKey: word.normalizedDate.yearMonthDayUTC0) == nil ? true : false
                }
                
                /// Requesting absent words from API, parsing them, saving to the DB.
                let remotePublisher = requiredDates.publisher
                    .flatMap { _, date -> AnyPublisher<WordnikWOD, APIError> in
                        self.apiService.GET(endpoint: .wordnik(.wod(date: date)))
                    }
                    .mapError { $0 as Error }
                    .compactMap { WordnikWODNormalized(wordnikWod: $0) }
                    .map { wodNormalized -> WordnikWODNormalized in
                        self.saveWOD(word: wodNormalized)
                        return wodNormalized
                    }
                
                /// Parsing words from DB
                let dbPublisher = mutableDBWords.publisher
                    .compactMap { word -> WordnikWODNormalized? in
                        WordnikWODNormalized(word: word)
                    }
                    .mapError { $0 as Error }
                
                /// Merging them together into one array
                return remotePublisher.merge(with: dbPublisher)
                    .collect()
                    .eraseToAnyPublisher()
            }
            .eraseToEffect()
    }
    
    func saveWOD(word: WordnikWODNormalized) {
        coreDataService.addWord(ofType: .wod,
                                title: word.title,
                                date: word.date,
                                definitions: [word.partOfSpeech : [word.definition]])
    }
}

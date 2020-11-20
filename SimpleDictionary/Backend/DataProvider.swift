//
//  DataProvider.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-14.
//

import Foundation
import Combine
import ComposableArchitecture

class WODDataProvider {
    
    private let apiService: APIService
    private let coreDataService: CoreDataService
    
    init(apiService: APIService, coreDataService: CoreDataService) {
        self.apiService = apiService
        self.coreDataService = coreDataService
        
        // deleteUnusedWODs()
    }
    
//    func fetchWODs() -> Effect<[Word], Never>{
//        let requiredCount = AppUserDefaults.countWODs
//        var dateComponents = DateComponents()
//        var requiredDates = [String : Date]()
//
//        for day in 0..<requiredCount {
//            dateComponents.day = -day
//            let date = Date().changed(with: dateComponents)
//            requiredDates[date.yearMonthDay] = date
//        }
//
//        coreDataService.fetchWords(ofType: .wod)
//            .replaceError(with: [])
//            .flatMap { dbWords -> Effect<String, Never> in
//                var sortedDBWords = dbWords.sorted { $0.unwrappedDate > $1.unwrappedDate }
//
//                sortedDBWords.removeAll { word in
//                    requiredDates.removeValue(forKey: word.unwrappedDate.yearMonthDay) == nil ? true : false
//                }
//
//                requiredDates.publisher
//                    .flatMap { _, date -> AnyPublisher<WordnikWOD, APIError> in
//                        self.apiService.GET(endpoint: .wordnik(.wod(date: date)))
//                    }
//                    .map { wordnikWOD -> Word? in
//
//                    }
//
//            }
//    }
}
//    func saveWordnikWOD(word: WordnikWOD) -> Effect<Word?, Never> {
//        guard let title = word.word,
//              let definitions = word.definitions,
//              let definitionEntity = definitions.first,
//              let partOfSpeech = definitionEntity.partOfSpeech,
//              let definition = definitionEntity.text
//        else { return Just(nil).eraseToEffect() }
//
//        return self.coreDataService.addWord(title: title,
//                                     definitions: [partOfSpeech : [definition]])
//    }
    
//    func deleteUnusedWODs() {
//        let requiredCount = AppUserDefaults.countWODs
//
//        coreDataService.fetchWords(ofType: .wod)
//            .tryCatch {
//
//            }
//
//    }

//
//  WordnikWOD.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-02.
//

import Foundation
import Combine

struct WordnikWOD: Decodable {
    let word: String?
    let definitions: [Definitions]?
    
    struct Definitions: Decodable {
        let text: String?
        let partOfSpeech: String?
    }
}

extension WordnikWOD {
    static func fetch(for date: Date) -> AnyPublisher<WordnikWOD, Never> {
        APIService.shared.GET(endpoint: .wordnik(.wod(date: date)))
            .print()
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: WordnikWOD(word: "nil", definitions: []))
            .eraseToAnyPublisher()
    }
}

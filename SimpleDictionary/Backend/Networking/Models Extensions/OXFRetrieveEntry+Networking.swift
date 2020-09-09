//
//  RetrieveEntry+Networking.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import Foundation
import Combine

extension OXFRetrieveEntry {
    static public func fetch(word: String) -> AnyPublisher<OXFRetrieveEntry, Never> {
        return API.shared.request(word: word)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: OXFRetrieveEntry(results: nil))
            .eraseToAnyPublisher()
    }
}

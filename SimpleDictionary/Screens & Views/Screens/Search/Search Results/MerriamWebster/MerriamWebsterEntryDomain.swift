//
//  MerriamWebsterEntryDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-05.
//

import Foundation
import ComposableArchitecture

struct MerriamWebsterEntryState: Equatable {
    let entry: StandardDictionaryEntry?
    var shuffledEntry: StandardDictionaryEntry? {
        if let entry = entry {
            return StandardDictionaryEntry(entries: entry.entries.shuffled(), etymologies: entry.etymologies)
        }
        else {
            return nil
        }
    }
}

enum MerriamWebsterEntryAction {
    case onAppear
}

struct MerriamWebsterEntryEnvironment { }

let merriamWebsterEntryReducer = Reducer<
MerriamWebsterEntryState, MerriamWebsterEntryAction, MerriamWebsterEntryEnvironment
> { state, action, environment in
    
    switch action {
    case .onAppear:
        return .none
    }
    
}

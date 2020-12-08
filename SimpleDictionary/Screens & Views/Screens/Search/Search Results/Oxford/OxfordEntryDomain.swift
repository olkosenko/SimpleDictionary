//
//  OxfordEntryDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-04.
//

import Foundation
import ComposableArchitecture

struct OxfordEntryState: Equatable {
    let entry: StandardDictionaryEntry
}

enum OxfordEntryAction {
    case onAppear
}

struct OxfordEntryEnvironment { }

let oxfordEntryReducer = Reducer<
    OxfordEntryState, OxfordEntryAction, OxfordEntryEnvironment
> { state, action, environment in
    
    switch action {
    case .onAppear:
        return .none
    }
    
}

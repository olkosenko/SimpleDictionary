//
//  UrbanEntryDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-03.
//

import Foundation
import ComposableArchitecture

struct UrbanEntryState: Equatable {
    let urbanEntry: UrbanEntry
}

enum UrbanEntryAction {
    case onAppear
}

struct UrbanEntryEnvironment { }

let urbanEntryReducer = Reducer<UrbanEntryState, UrbanEntryAction, UrbanEntryEnvironment> {
    state, action, environment in
    
    switch action {
    case .onAppear:
        return .none
    }
    
}



//
//  SearchDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-12.
//

import Foundation
import ComposableArchitecture

struct SearchState {
    var searchQuery = ""
    var recentSearches: [String]
    var wordsOfTheDay: [WordnikWOD]
}

enum SearchAction {
    case searchQueryChanged(String)
}

struct SearchEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment> {
    state, action, enviroment in
    
    switch action {
    case .searchQueryChanged(let query):
        state.searchQuery = query
        return .none
    }
}

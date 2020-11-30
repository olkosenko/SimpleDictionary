//
//  SearchDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-12.
//

import Foundation
import ComposableArchitecture

struct SearchState: Equatable {
    var searchQuery = ""
    var isSearchQueryEditing = false
    var searchSuggestion = [String]()
    var recentSearches = [String]()
    
    var wordsOfTheDay = [WordnikWODNormalized]()
    
    var onAppearCalled = false /// Fixes unexpected behaviour when onAppear is called multiple times
}

enum SearchAction {
    case onAppear
    
    case searchQueryChanged(String)
    case searchSuggestionsReceived(Result<[String], Never>)
    
    case wodsReceived(Result<[WordnikWODNormalized], Error>)
    
    case searchQueryEditing(Bool)
}

struct SearchEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var searchDataProvider: SearchDataProvider
}

let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment> {
    state, action, environment in
    
    switch action {
    case .onAppear:
        if !state.onAppearCalled {
            state.onAppearCalled = true
            return environment.searchDataProvider.fetchWODs()
                .subscribe(on: DispatchQueue.global(qos: .userInitiated))
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SearchAction.wodsReceived)
        }
        return .none
    
    case .wodsReceived(.success(let wods)):
        state.wordsOfTheDay = wods
        return .none
        
    case .wodsReceived(.failure):
        return .none
        
    case .searchQueryChanged(let query):
        struct SearchSuggestionsID: Hashable {}
        
        state.searchQuery = query
        
        guard query.isNotEmpty else { return .cancel(id: SearchSuggestionsID()) }
        return environment.searchDataProvider.fetchWordSuggestions(for: query)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: environment.mainQueue)
            .catchToEffect()
            //.debounce(id: SearchSuggestionsID(), for: 0.3, scheduler: environment.mainQueue)
            .map(SearchAction.searchSuggestionsReceived)
        
    case .searchSuggestionsReceived(.success(let suggestions)):
        state.searchSuggestion = suggestions
        return .none
        
    case .searchSuggestionsReceived(.failure):
        return .none
        
    case .searchQueryEditing(let newValue):
        state.isSearchQueryEditing = newValue
        return .none
        
    }
}
.debug()

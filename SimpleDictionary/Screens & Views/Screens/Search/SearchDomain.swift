//
//  SearchDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-12.
//

import Foundation
import ComposableArchitecture

struct SearchState: Equatable {
    var settings = SearchSettingsState()
    var dashboard = DashboardState()
    
    var searchResults: SearchResultsState?
    var searchResultsTitle: String?
    
    var searchQuery = ""
    var isSearchQueryEditing = false
    var searchSuggestion = [String]()
    var recentSearches = [String]()
    
    var wordsOfTheDay = [WordnikWODNormalized]()
    
    var isInitialOnAppear = true
    var isSettingsSheetPresented = false
}

enum SearchAction {
    case settings(SearchSettingsAction)
    case dashboard(DashboardAction)
    case searchResults(SearchResultsAction)
    
    case onAppear
    case wodsReceived(Result<[WordnikWODNormalized], Never>)
    case onRecentSearchesChanged(Result<[String], Never>)
    
    case searchQueryChanged(String)
    case searchQueryEditing(Bool)
    case searchSuggestionsReceived(Result<[String], Never>)
    
    case setSettingsSheet(Bool)
    case setNavigation(String?)
}

struct SearchEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var searchDataProvider: SearchDataProvider
    var userDefaultsDataProvider: UserDefaultsDataProvider
}

struct SearchSuggestionsID: Hashable {}

let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment>.combine(
    searchResultsReducer
    .optional()
    .pullback(
        state: \.searchResults,
        action: /SearchAction.searchResults,
        environment: { .init(mainQueue: $0.mainQueue, dataProvider: $0.searchDataProvider) }
    ),
    searchSettingsReducer
    .pullback(
        state: \.settings,
        action: /SearchAction.settings,
        environment: { .init(userDefaultsDataProvider: $0.userDefaultsDataProvider) }
    ),
    dashboardReducer
    .pullback(
        state: \.dashboard,
        action: /SearchAction.dashboard,
        environment: { .init(userDefaultsDataProvider: $0.userDefaultsDataProvider) }
    ),
    Reducer { state, action, environment in
        
        switch action {
        
        case .settings, .dashboard, .searchResults:
            return .none
            
        case .onAppear:
            if state.isInitialOnAppear {
                state.isInitialOnAppear = false
                
                return .concatenate(
                    environment.searchDataProvider.fetchWODs()
                        .subscribe(on: DispatchQueue.global(qos: .userInitiated))
                        .receive(on: environment.mainQueue)
                        .catchToEffect()
                        .map(SearchAction.wodsReceived),
                    
                    environment.userDefaultsDataProvider.recentSearchesPublisher
                        .catchToEffect()
                        .map(SearchAction.onRecentSearchesChanged),
                    
                    environment.userDefaultsDataProvider.recentSearchesPublisher
                        .catchToEffect()
                        .map(SearchAction.searchSuggestionsReceived)
                )
            }
            return .none
            
        case .wodsReceived(.success(let wods)):
            state.wordsOfTheDay = wods.sorted { $0.date > $1.date }
            return .none
            
        case .onRecentSearchesChanged(.success(let newRecentSearches)):
            state.recentSearches = newRecentSearches
            return .none
            
        case .searchQueryChanged(let query):
            state.searchQuery = query
            
            guard query.isNotEmpty else {
                state.searchSuggestion.removeAll()
                return .cancel(id: SearchSuggestionsID())
            }
            
            return environment.searchDataProvider.fetchWordSuggestions(for: query)
                .subscribe(on: DispatchQueue.global(qos: .userInitiated))
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .debounce(id: SearchSuggestionsID(), for: 0.3, scheduler: environment.mainQueue)
                .map(SearchAction.searchSuggestionsReceived)
            
        case .searchSuggestionsReceived(.success(let suggestions)):
            state.searchSuggestion = suggestions
            return .none
            
        case .searchQueryEditing(let newValue):
            state.isSearchQueryEditing = newValue
            return .none
            
        case .setSettingsSheet(let newValue):
            state.isSettingsSheetPresented = newValue
            return .none
            
        case .setNavigation(.some(let word)):
            state.searchResultsTitle = word
            state.searchResults = SearchResultsState(word: word)
            return .concatenate(
                .fireAndForget {
                    environment.userDefaultsDataProvider.increaseCurrentSearchCount()
                },
                .fireAndForget {
                    environment.userDefaultsDataProvider.addRecentSearch(word)
                },
                .init(value: .searchQueryChanged(word))
            )
            
        case .setNavigation(.none):
            environment.searchDataProvider.resetAudioPlayer()
            
            state.searchResultsTitle = nil
            state.searchResults = nil
            
            return .none
            
        }
    }
)


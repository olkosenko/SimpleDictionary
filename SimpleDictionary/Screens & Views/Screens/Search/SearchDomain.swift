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
    var dashboard = DashboardState(metrics: [])
    
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
    
    case onAppear
    case wodsReceived(Result<[WordnikWODNormalized], Error>)
    case recentSearchesReceived(Result<[String], Never>)
    
    case searchQueryChanged(String)
    case searchQueryEditing(Bool)
    case searchSuggestionsReceived(Result<[String], Never>)
    
    case setSettingsSheet(Bool)
}

struct SearchEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var searchDataProvider: SearchDataProvider
}

let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment>.combine(
    searchSettingsReducer
    .pullback(
        state: \.settings,
        action: /SearchAction.settings,
        environment: { _ in .init() }
    ),
    dashboardReducer
    .pullback(
        state: \.dashboard,
        action: /SearchAction.dashboard,
        environment: { _ in .init() }
    ),
    Reducer { state, action, environment in
        
        switch action {
        
        case .settings:
            return .none
            
        case .dashboard:
            return .none
            
        case .onAppear:
            if state.isInitialOnAppear {
                state.isInitialOnAppear = false
                
                state.settings.isSearchGoalActive = environment.searchDataProvider.isSearchGoalActive
                state.settings.isLearnGoalActive = environment.searchDataProvider.isLearnGoalActive
                state.settings.searchGoal = Double(environment.searchDataProvider.searchGoalCount)
                state.settings.learnGoal = Double(environment.searchDataProvider.learnGoalCount)
                
                return .concatenate(
                    environment.searchDataProvider.fetchWODs()
                        .subscribe(on: DispatchQueue.global(qos: .userInitiated))
                        .receive(on: environment.mainQueue)
                        .catchToEffect()
                        .map(SearchAction.wodsReceived),
                    
                    environment.searchDataProvider.fetchListOfRecentSearches()
                        .receive(on: environment.mainQueue)
                        .catchToEffect()
                        .map(SearchAction.recentSearchesReceived)
                )
            }
            return .none
            
        case .wodsReceived(.success(let wods)):
            state.wordsOfTheDay = wods.sorted { $0.date > $1.date }
            return .none
            
        case .wodsReceived(.failure):
            return .none
            
        case .recentSearchesReceived(.success(let recentSearches)):
            state.recentSearches = recentSearches
            return .none
            
        case .recentSearchesReceived(.failure):
            return .none
            
        case .searchQueryChanged(let query):
            struct SearchSuggestionsID: Hashable {}
            
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
            
        case .searchSuggestionsReceived(.failure):
            return .none
            
        case .searchQueryEditing(let newValue):
            state.isSearchQueryEditing = newValue
            return .none
            
        case .setSettingsSheet(let newValue):
            state.isSettingsSheetPresented = newValue
            return .none
            
        }
    }
)

//
//  SearchResultsDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-03.
//

import Foundation
import ComposableArchitecture

struct SearchResultsState: Equatable {
    let word: String
    let tabs: [DictionaryTab] = [.urban, .merriamwebster, .oxford]
    var currentTab = DictionaryTab.urban
    
    var isAudioAvailable = false
}

enum SearchResultsAction {
    case onAppear
    
    case selectTab(DictionaryTab)
    
    case playAudio
    case audioResponseReceived(Result<Bool, Never>)
}

struct SearchResultsEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var dataProvider: SearchDataProvider
}

let searchResultsReducer = Reducer<SearchResultsState, SearchResultsAction, SearchResultsEnvironment>.combine(
    Reducer { state, action, environment in
        
        switch action {
        
        case .onAppear:
            return environment.dataProvider.fetchDefaultAudio(for: state.word)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SearchResultsAction.audioResponseReceived)
            
        case .selectTab(let tab):
            state.currentTab = tab
            return .none
            
        case .playAudio:
            environment.dataProvider.playWordAudioIfAvailable()
            return .none
            
        case .audioResponseReceived(.success(let isAudioAvailable)):
            state.isAudioAvailable = isAudioAvailable
            return .none
            
        case .audioResponseReceived(.failure):
            return .none
            
        }
    }
)
.debug()

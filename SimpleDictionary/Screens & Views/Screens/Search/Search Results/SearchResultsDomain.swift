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
    
    var urbanEntryState: UrbanEntryState?
    
    var isAudioAvailable = false
}

enum SearchResultsAction {
    case urbanEntry(UrbanEntryAction)
    
    case onAppear
    
    case selectTab(DictionaryTab)
    
    case fetchDataForCurrentTabIfNeeded
    case urbanResponseReceived(Result<UrbanEntry, Never>)
    
    case playAudio
    case audioResponseReceived(Result<Bool, Never>)
}

struct SearchResultsEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var dataProvider: SearchDataProvider
}

let searchResultsReducer = Reducer<SearchResultsState, SearchResultsAction, SearchResultsEnvironment>.combine(
    urbanEntryReducer
    .optional()
    .pullback(
        state: \.urbanEntryState,
        action: /SearchResultsAction.urbanEntry,
        environment: { _ in .init() }
    ),
    
    Reducer { state, action, environment in
        
        switch action {
        
        case .urbanEntry:
            return .none
        
        case .onAppear:
            return .concatenate(
                environment.dataProvider.fetchDefaultAudio(for: state.word)
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(SearchResultsAction.audioResponseReceived),
                
                .init(value: .fetchDataForCurrentTabIfNeeded)
            )
            
        case .fetchDataForCurrentTabIfNeeded:
            switch state.currentTab {
            
            case .urban:
                guard state.urbanEntryState == nil else { return .none }
                return environment.dataProvider.fetchUrbanDictionary(for: state.word)
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(SearchResultsAction.urbanResponseReceived)
                
            case .merriamwebster, .oxford:
                return .none
                
            }
            
        case .urbanResponseReceived(.success(var urbanEntry)):
            state.urbanEntryState = .init(urbanEntry: urbanEntry)
            return .none
            
        case .urbanResponseReceived(.failure):
            return .none
            
        case .selectTab(let tab):
            state.currentTab = tab
            return .init(value: SearchResultsAction.fetchDataForCurrentTabIfNeeded)
            
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

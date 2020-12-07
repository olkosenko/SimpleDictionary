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
    
    let tabs: [DictionaryTab] = [.oxford, .merriamwebster, .urban]
    var currentTab = DictionaryTab.merriamwebster
    
    var urbanEntryState: UrbanEntryState?
    var merriamWebsterEntryState: MerriamWebsterEntryState?
    
    var isAudioAvailable = false
}

enum SearchResultsAction {
    case urbanEntry(UrbanEntryAction)
    case merriamWebster(MerriamWebsterEntryAction)
    
    case onAppear
    
    case selectTab(DictionaryTab)
    
    case fetchDataForCurrentTabIfNeeded
    case urbanResponseReceived(Result<UrbanEntry, Never>)
    case merriamWebsterResponseReceived(Result<MerriamWebsterEntry, Never>)
    
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
    merriamWebsterEntryReducer
    .optional()
    .pullback(
        state: \.merriamWebsterEntryState,
        action: /SearchResultsAction.merriamWebster,
        environment: { _ in .init() }
    ),
    Reducer { state, action, environment in
        
        switch action {
        
        case .urbanEntry, .merriamWebster:
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
                
            case .merriamwebster:
                guard state.merriamWebsterEntryState == nil else { return .none }
                return environment.dataProvider.fetchMerriamWebsterDictionary(for: state.word)
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(SearchResultsAction.merriamWebsterResponseReceived)
                
            case .oxford:
                return .none
                
            }
            
        case .urbanResponseReceived(.success(let urbanEntry)):
            state.urbanEntryState = .init(urbanEntry: urbanEntry)
            return .none
            
        case .urbanResponseReceived(.failure):
            return .none
            
        case .merriamWebsterResponseReceived(.success(let merriamWebsterEntry)):
            state.merriamWebsterEntryState = .init(def: [])
            return .none
            
        case .merriamWebsterResponseReceived(.failure):
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

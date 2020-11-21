//
//  PersonalDictionaryDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-20.
//

import Foundation
import ComposableArchitecture
import Combine

struct PersonalDictionaryState: Equatable {
    var wordCreation =  ManualWordCreationState()
    var words = [Word]()
    var isSheetPresented = false
}

enum PersonalDictionaryAction {
    case wordCreation(ManualWordCreationAction)
    
    case onAppear
    case onWordsFetched(Result<[Word], Error>)
    
    case setSheet(Bool)
    case removeWord(IndexSet)   
}

struct PersonalDictionaryEnvironment {
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let personalDictionaryDataProvider: PersonalDictionaryDataProvider
}

let personalDictionaryReducer = Reducer<
    PersonalDictionaryState, PersonalDictionaryAction, PersonalDictionaryEnvironment
>.combine(
    manualWordAddingReducer
        .pullback(
            state: \.wordCreation,
            action: /PersonalDictionaryAction.wordCreation,
            environment: { .init(mainQueue: $0.mainQueue, dataProvider: $0.personalDictionaryDataProvider, uuid: UUID.init) }
        ),
    Reducer { state, action, environment in
        
        switch action {
        
        case .wordCreation:
            return .none
            
        case .onAppear:
            return environment.personalDictionaryDataProvider.fetchWords()
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(PersonalDictionaryAction.onWordsFetched)
            
        case .onWordsFetched(.success(let words)):
            state.words = words
            return .none
            
        case .onWordsFetched(.failure):
            return .none
            
        case .setSheet(true):
            state.isSheetPresented = true
            state.wordCreation = ManualWordCreationState()
            return .none
            
        case .setSheet(false):
            state.isSheetPresented = false
            return .none
            
        case .removeWord(let indexSet):
            state.words.remove(atOffsets: indexSet)
            return .none
            
        }
    }
)
.debug()

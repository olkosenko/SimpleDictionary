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
    var selectionWord: Word?
    var selectionState: WordDetailsState?
    
    var words = [Word]()
    var isSheetPresented = false
}

enum PersonalDictionaryAction {
    case wordCreation(ManualWordCreationAction)
    case wordDetails(WordDetailsAction)
    
    case onAppear
    case onDisappear
    case onWordsFetched(Result<[Word], Error>)
    
    case setSheet(Bool)
    case setNavigation(selection: Word?)
    
    case deleteWord(IndexSet)
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
    wordDetailsReducer
    .optional()
    .pullback(
        state: \.selectionState,
        action: /PersonalDictionaryAction.wordDetails,
        environment: { _ in WordDetailsEnvironment(uuid: UUID.init) }
    ),
    Reducer { state, action, environment in
        
        struct WordFetchId: Hashable {}
        
        switch action {
        
        case .wordCreation:
            return .none
            
        case .wordDetails:
            return .none
            
        case .onAppear:
            return environment.personalDictionaryDataProvider.wordsPublisher
                .subscribe(on: DispatchQueue.global())
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(PersonalDictionaryAction.onWordsFetched)
                .cancellable(id: WordFetchId())
            
        case .onDisappear:
            return .cancel(id: WordFetchId())
            
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
            
        case .deleteWord(let indexSet):
            let wordsToDelete = indexSet.map { state.words[$0] }
            environment.personalDictionaryDataProvider.deleteWords(wordsToDelete)
            return .none
            
        case .setNavigation(selection: .some(let word)):
            state.selectionWord = word
            
            let definitions = word.normalizedDefinitions.map { EditableDefinition(id: $0.normalizedId,
                                                                                  title: $0.normalizedTitle,
                                                                                  partOfSpeech: $0.normalizedPartOfSpeech)}
            
            state.selectionState = WordDetailsState(word: word.normalizedTitle,
                                                    definitions: IdentifiedArrayOf(definitions))
            return .none
            
        case .setNavigation(selection: .none):
            
            state.selectionWord = nil
            state.selectionState = nil
            return .none
            
        }
        
    }
)

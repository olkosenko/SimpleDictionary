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
    var wordCreation = ManualWordCreationState()
    var isWordCreationSheetPresented = false
    
    var selectionWord: Word?
    var selectionState: WordDetailsState?
    
    var settings = PersonalDictionarySettingsState()
    var searchSettings: PersonalDictionarySettings = .defaultValue
    var isSettingsSheetPresented = false
    
    var words = [Word]()
    var isActivityIndicatorVisible = true
}

enum PersonalDictionaryAction {
    case wordCreation(ManualWordCreationAction)
    case wordDetails(WordDetailsAction)
    case settings(PersonalDictionarySettingsAction)
    
    case onAppear
    case onDisappear
    case onWordsFetched(Result<[Word], Error>)
    case onSettingsChanged(Result<PersonalDictionarySettings, Never>)
    
    case setWordCreationSheet(Bool)
    case setSettingsSheet(Bool)
    case setNavigation(selection: Word?)
    
    case deleteWord(IndexSet)
}

struct PersonalDictionaryEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var personalDictionaryDataProvider: PersonalDictionaryDataProvider
    var userDefaultsDataProvider: UserDefaultsDataProvider
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
    personalDictionarySettingsReducer
        .pullback(
            state: \.settings,
            action: /PersonalDictionaryAction.settings,
            environment: { .init(userDefaultsDataProvider: $0.userDefaultsDataProvider) }
        ),
    
    wordDetailsReducer
        .optional()
        .pullback(
            state: \.selectionState,
            action: /PersonalDictionaryAction.wordDetails,
            environment: { WordDetailsEnvironment(dataProvider: $0.personalDictionaryDataProvider, uuid: UUID.init) }
        ),
    Reducer { state, action, environment in
        
        switch action {
        
        case .wordCreation, .wordDetails, .settings:
            return .none
            
        case .onAppear:
            return .merge(
                environment.personalDictionaryDataProvider.wordsPublisher
                    .delay(for: .seconds(0.3), scheduler: environment.mainQueue)
                    .subscribe(on: DispatchQueue.global())
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(PersonalDictionaryAction.onWordsFetched),
                
                environment.userDefaultsDataProvider.dictionarySettingsPublisher
                    .catchToEffect()
                    .map(PersonalDictionaryAction.onSettingsChanged)
            )
            
        case .onDisappear:
            return .none
            
        case .onWordsFetched(.success(let words)):
            state.words = words.sorted(by: { $0.normalizedTitle < $1.normalizedTitle })
            state.isActivityIndicatorVisible = false
            return .none
            
        case .onSettingsChanged(.success(let newSettings)):
            state.searchSettings = newSettings
            return .none
            
        case .setWordCreationSheet(true):
            state.isWordCreationSheetPresented = true
            state.wordCreation = ManualWordCreationState()
            return .none
            
        case .setWordCreationSheet(false):
            state.isWordCreationSheetPresented = false
            return .none
            
        case .setSettingsSheet(let newValue):
            state.isSettingsSheetPresented = newValue
            return .none
            
        case .deleteWord(let indexSet):
            let wordsToDelete = indexSet.map { state.words[$0] }
            environment.personalDictionaryDataProvider.deleteWords(wordsToDelete)
            return .none
            
        case .setNavigation(selection: .some(let word)):
            let definitions = word.normalizedDefinitions.sorted { w1, w2 in
                w1.normalizedTitle < w2.normalizedTitle
            }
            .map {
                EditableDefinition(id: $0.normalizedId,
                                   title: $0.normalizedTitle,
                                   partOfSpeech: $0.normalizedPartOfSpeech) }
            
            state.selectionWord = word
            state.selectionState = WordDetailsState(title: word.normalizedTitle,
                                                    definitions: IdentifiedArrayOf(definitions))
            
            return .none
            
        case .setNavigation(selection: .none):
            guard let word = state.selectionWord, let definitions = state.selectionState?.definitions else {
                return .none
            }
            
            let editableDefinitions = Array(definitions)
            state.selectionWord = nil
            state.selectionState = nil
            
            return .fireAndForget {
                environment.personalDictionaryDataProvider
                    .handleWordStateChanges(for: word, editableDefinitions: editableDefinitions)
            }
            
        case .onWordsFetched(.failure):
            return .none
        }
        
    }
)

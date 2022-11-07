//
//  SimpleDictionaryTests.swift
//  SimpleDictionaryTests
//
//  Created by Oleg Kosenko on 2020-11-02.
//

import XCTest
import ComposableArchitecture

@testable import SimpleDictionary

class MuchosTests: XCTestCase {
    let scheduler = DispatchQueue.testScheduler
    let dependencies = AppDependencyManager()

    func testDictionaryAddWordButtonPressed() {
        let store = TestStore(
            initialState: PersonalDictionaryState(),
            reducer: personalDictionaryReducer,
            environment: PersonalDictionaryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                personalDictionaryDataProvider: dependencies.personalDictionaryDataProvider,
                userDefaultsDataProvider: dependencies.userDefaultsDataProvider
            )
        )
        
        store.assert(
            .send(.setWordCreationSheet(true)) {
                $0.isWordCreationSheetPresented = true
            }
        )
    }
    
    
    func testDictionarySettingsButtonPressed() {
        let store = TestStore(
            initialState: PersonalDictionaryState(),
            reducer: personalDictionaryReducer,
            environment: PersonalDictionaryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                personalDictionaryDataProvider: dependencies.personalDictionaryDataProvider,
                userDefaultsDataProvider: dependencies.userDefaultsDataProvider
            )
        )
        
        store.assert(
            .send(.setSettingsSheet(true)) {
                $0.isSettingsSheetPresented = true
            }
        )
    }
    
    func testDictionaryWordSelected() {
        let word1 = Word(context: dependencies.coreDataStore.mainContext)
        let word2 = Word(context: dependencies.coreDataStore.mainContext)
        let word3 = Word(context: dependencies.coreDataStore.mainContext)
        word1.title = "Test"
        word2.title = "Wrong"
        word3.title = "Wrong"
        
        let store = TestStore(
            initialState: PersonalDictionaryState(words: [word1, word2, word3]),
            reducer: personalDictionaryReducer,
            environment: PersonalDictionaryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                personalDictionaryDataProvider: dependencies.personalDictionaryDataProvider,
                userDefaultsDataProvider: dependencies.userDefaultsDataProvider
            )
        )
        
        store.assert(
            .send(.setNavigation(selection: word1)) {
                $0.selectionState = .init(title: "Test", definitions: [])
                $0.selectionWord = word1
            }
        )
    }
    
    func testDictionaryDeleteWord() {
        let word1 = Word(context: dependencies.coreDataStore.mainContext)
        let word2 = Word(context: dependencies.coreDataStore.mainContext)
        let word3 = Word(context: dependencies.coreDataStore.mainContext)
        
        let store = TestStore(
            initialState: PersonalDictionaryState(words: [word1, word2, word3]),
            reducer: personalDictionaryReducer,
            environment: PersonalDictionaryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                personalDictionaryDataProvider: dependencies.personalDictionaryDataProvider,
                userDefaultsDataProvider: dependencies.userDefaultsDataProvider
            )
        )
        
        store.assert(
            .send(.deleteWord([1])) {
                $0.words = [
                    $0.words[0],
                    $0.words[2]
                ]
            }
        )
    }
    
    func testSearchQueryChanged() {
        let store = TestStore(
            initialState: SearchState(),
            reducer: searchReducer,
            environment: SearchEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                searchDataProvider: dependencies.searchDataProvider,
                userDefaultsDataProvider: dependencies.userDefaultsDataProvider
            )
        )
        
        store.assert(
            .send(.searchQueryChanged("Dictionary")) {
                $0.searchQuery = "Dictionary"
            },
            .send(.searchQueryChanged("")) {
                $0.searchQuery = ""
            }
        )
    }
    
    func testSearchSuggestions() {
        let store = TestStore(
            initialState: SearchState(),
            reducer: searchReducer,
            environment: SearchEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                searchDataProvider: dependencies.searchDataProvider,
                userDefaultsDataProvider: dependencies.userDefaultsDataProvider
            )
        )
        
        store.assert(
            .send(.searchQueryChanged("Dictionary")) {
                $0.searchQuery = "Dictionary"
            },
            .send(.searchQueryChanged("")) {
                $0.searchQuery = ""
            }
        )
    }
    
    func testWordSearch() {
        let store = TestStore(
            initialState: SearchState(),
            reducer: searchReducer,
            environment: SearchEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                searchDataProvider: dependencies.searchDataProvider,
                userDefaultsDataProvider: dependencies.userDefaultsDataProvider
            )
        )
        
        store.assert(
            .send(.searchQueryChanged("Dictionary")) {
                $0.searchQuery = "Dictionary"
            },
            .send(.searchQueryChanged("")) {
                $0.searchQuery = ""
            }
        )
    }
    

}

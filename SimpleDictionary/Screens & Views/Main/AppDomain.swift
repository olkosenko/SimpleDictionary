//
//  AppDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-20.
//

import Foundation
import ComposableArchitecture

struct AppState: Equatable {
    var search = SearchState()
    var personalDictionary = PersonalDictionaryState()
}

enum AppAction {
    case search(SearchAction)
    case personalDictionary(PersonalDictionaryAction)
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var searchDataProvider: SearchDataProvider
    var personalDictionaryDataProvider: PersonalDictionaryDataProvider
    var userDefaultsDataProvider: UserDefaultsDataProvider
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    searchReducer
        .pullback(
            state: \.search,
            action: /AppAction.search,
            environment: { .init(mainQueue: $0.mainQueue,
                                 searchDataProvider: $0.searchDataProvider,
                                 userDefaultsDataProvider: $0.userDefaultsDataProvider) }
        ),
    
    personalDictionaryReducer
        .pullback(
            state: \.personalDictionary,
            action: /AppAction.personalDictionary,
            environment: { .init(mainQueue: $0.mainQueue,
                                 personalDictionaryDataProvider: $0.personalDictionaryDataProvider,
                                 userDefaultsDataProvider: $0.userDefaultsDataProvider) }
        )
)

#if DEBUG
extension AppEnvironment {
    static let debug: AppEnvironment = {
        let dependencyManager = AppDependencyManager()
        return AppEnvironment(mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                              searchDataProvider: dependencyManager.searchDataProvider,
                              personalDictionaryDataProvider: dependencyManager.personalDictionaryDataProvider,
                              userDefaultsDataProvider: dependencyManager.userDefaultsDataProvider)
    }()
}

enum DebugStore {
    static let store = Store(initialState: AppState(), reducer: appReducer, environment: AppEnvironment.debug)
}
#endif

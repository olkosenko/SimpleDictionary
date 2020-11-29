//
//  AppDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-20.
//

import Foundation
import ComposableArchitecture

struct AppState: Equatable {
    var personalDictionary = PersonalDictionaryState()
}

enum AppAction {
    case personalDictionary(PersonalDictionaryAction)
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var wodDataProvider: WODDataProvider
    var personalDictionaryDataProvider: PersonalDictionaryDataProvider
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    personalDictionaryReducer
        .pullback(
            state: \.personalDictionary,
            action: /AppAction.personalDictionary,
            environment: { .init(mainQueue: $0.mainQueue,
                                 personalDictionaryDataProvider: $0.personalDictionaryDataProvider) })
)

#if DEBUG
extension AppEnvironment {
    static let debug: AppEnvironment = {
        let dependencyManager = AppDependencyManager()
        return AppEnvironment(mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                              wodDataProvider: dependencyManager.wodDataProvider,
                              personalDictionaryDataProvider: dependencyManager.personalDictionaryDataProvider)
    }()
}

enum DebugStore {
    static let store = Store(initialState: AppState(), reducer: appReducer, environment: AppEnvironment.debug)
}
#endif

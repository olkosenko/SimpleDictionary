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
    var wodDataProdiver: WODDataProvider
    var personalDictionaryDataProvider: PersonalDictionaryDataProvider
    
//    static let live = Self(
//        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
//        wodDataProdiver: ,
//        personalDictionaryDataProvider: <#T##PersonalDictionaryDataProvider#>
//    )
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    personalDictionaryReducer
        .pullback(
            state: \.personalDictionary,
            action: /AppAction.personalDictionary,
            environment: { .init(mainQueue: $0.mainQueue,
                                 personalDictionaryDataProvider: $0.personalDictionaryDataProvider) })
)

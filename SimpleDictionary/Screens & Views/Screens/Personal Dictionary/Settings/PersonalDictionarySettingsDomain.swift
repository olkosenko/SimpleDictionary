//
//  PersonalDictionarySettingsDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-28.
//

import Foundation
import ComposableArchitecture

struct PersonalDictionarySettingsState: Equatable {
    var settings = PersonalDictionarySettings.defaultValue
}

enum PersonalDictionarySettingsAction {
    case onAppear
    case onSettingsChanged(Result<PersonalDictionarySettings, Never>)
    
    case toggleChange(isOn: Bool)
}

struct PersonalDictionarySettingsEnvironment {
    var userDefaultsDataProvider: UserDefaultsDataProvider
}

let personalDictionarySettingsReducer = Reducer<
    PersonalDictionarySettingsState, PersonalDictionarySettingsAction, PersonalDictionarySettingsEnvironment
> { state, action, environment in
    
    switch action {
    
    case .onAppear:
        return environment.userDefaultsDataProvider.dictionarySettingsPublisher
            .catchToEffect()
            .map(PersonalDictionarySettingsAction.onSettingsChanged)
        
    case .onSettingsChanged(.success(let newSettings)):
        state.settings = newSettings
        return .none
    
    case .toggleChange(let isOn):
        return .fireAndForget {
            environment.userDefaultsDataProvider.changeDictionarySettings(\.isDictionaryDateShown, newValue: isOn)
        }
        
    }
}

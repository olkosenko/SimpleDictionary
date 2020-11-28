//
//  PersonalDictionarySettingsDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-28.
//

import Foundation
import ComposableArchitecture

struct PersonalDictionarySettingsState: Equatable {
    var showDate: Bool
}

enum PersonalDictionarySettingsAction {
    case toggleChange(isOn: Bool)
}

struct PersonalDictionarySettingsEnvironment {}

let personalDictionarySettingsReducer = Reducer<
    PersonalDictionarySettingsState, PersonalDictionarySettingsAction, PersonalDictionarySettingsEnvironment
> { state, action, environment in
    
    switch action {
    case .toggleChange(isOn: let newValue):
        state.showDate = newValue
        UserDefaults.standard.isDictionaryDateShown = newValue
        return .none
    }
    
}

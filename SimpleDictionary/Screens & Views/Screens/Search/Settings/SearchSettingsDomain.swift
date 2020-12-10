//
//  SearchSettingsDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-01.
//

import Foundation
import ComposableArchitecture

struct SearchSettingsState: Equatable {
    var settings = SearchSettings.defaultValue
    
    let sliderRange: ClosedRange<Double> = 5...30
    let sliderStep: Double = 5
}

enum SearchSettingsAction {
    case onAppear
    
    case onSettingsChanged(Result<SearchSettings, Never>)
    
    case searchToggleChange(isOn: Bool)
    case learnToggleChange(isOn: Bool)
    
    case searchSliderChange(Double)
    case learnSliderChange(Double)
}

struct SearchSettingsEnvironment {
    var userDefaultsDataProvider: UserDefaultsDataProvider
}

let searchSettingsReducer = Reducer<
    SearchSettingsState, SearchSettingsAction, SearchSettingsEnvironment
> { state, action, environment in
    
    switch action {
    case .onAppear:
        return environment.userDefaultsDataProvider.searchSettingsPublisher
            .catchToEffect()
            .map(SearchSettingsAction.onSettingsChanged)
            
    case .onSettingsChanged(.success(let newSettings)):
        state.settings = newSettings
        return .none
    
    case .searchToggleChange(let isOn):
        return .fireAndForget {
            environment.userDefaultsDataProvider.changeSearchSettings(\.isSearchGoalActive, newValue: isOn)
        }
        
    case .learnToggleChange(let isOn):
        return .fireAndForget {
            environment.userDefaultsDataProvider.changeSearchSettings(\.isLearnGoalActive, newValue: isOn)
        }
        
    case .searchSliderChange(let newValue):
        return .fireAndForget {
            environment.userDefaultsDataProvider.changeSearchSettings(\.searchGoalCount, newValue: Int(newValue))
        }
        
    case .learnSliderChange(let newValue):
        return .fireAndForget {
            environment.userDefaultsDataProvider.changeSearchSettings(\.learnGoalCount, newValue: Int(newValue))
        }
        
    }
}

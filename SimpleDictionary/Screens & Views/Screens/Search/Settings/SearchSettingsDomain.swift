//
//  SearchSettingsDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-01.
//

import Foundation
import ComposableArchitecture

struct SearchSettingsState: Equatable {
    var isSearchGoalActive: Bool = true
    var isLearnGoalActive: Bool = true
    
    var searchGoal: Double = 30
    var learnGoal: Double = 30
    
    let sliderRange: ClosedRange<Double> = 5...30
    let sliderStep: Double = 5
}

enum SearchSettingsAction {
    case searchToggleChange(isOn: Bool)
    case learnToggleChange(isOn: Bool)
    
    case searchSliderChange(Double)
    case learnSliderChange(Double)
}

struct SearchSettingsEnvironment {}

let searchSettingsReducer = Reducer<
    SearchSettingsState, SearchSettingsAction, SearchSettingsEnvironment
> { state, action, environment in
    
    switch action {
    case .searchToggleChange(let isOn):
        state.isSearchGoalActive = isOn
        return .none
        
    case .learnToggleChange(let isOn):
        state.isLearnGoalActive = isOn
        return .none
        
    case .searchSliderChange(let newValue):
        state.searchGoal = newValue
        return .none
        
    case .learnSliderChange(let newValue):
        state.learnGoal = newValue
        return .none
    }
    
}
.debug()

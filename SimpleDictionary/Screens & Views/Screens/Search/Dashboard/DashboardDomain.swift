//
//  DashboardDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-01.
//

import Foundation
import ComposableArchitecture

struct DashboardState: Equatable {
    var settings: SearchSettings = .defaultValue
    
    var searchProgress: Double {
        return Double(settings.currentSearchCount) / Double(settings.searchGoalCount)
    }
    
    var learnProgress: Double {
        return Double(settings.currentLearnCount) / Double(settings.learnGoalCount)
    }
}

enum DashboardAction {
    case onAppear
    case onSettingsChanged(Result<SearchSettings, Never>)
}
struct DashboardEnvironment {
    var userDefaultsDataProvider: UserDefaultsDataProvider
}

let dashboardReducer = Reducer<DashboardState, DashboardAction, DashboardEnvironment> {
    state, action, environment in
    
    switch action {
    case .onAppear:
        return environment.userDefaultsDataProvider.searchSettingsPublisher
            .catchToEffect()
            .map(DashboardAction.onSettingsChanged)
        
    case .onSettingsChanged(.success(let newSettings)):
        state.settings = newSettings
        return .none
        
    }
}

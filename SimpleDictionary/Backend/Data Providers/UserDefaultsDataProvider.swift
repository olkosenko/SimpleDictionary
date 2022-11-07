//
//  UserDefaultsDataProvider.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-09.
//

import Foundation
import ComposableArchitecture

class UserDefaultsDataProvider {
    
    var searchSettingsPublisher: Effect<SearchSettings, Never> {
        UserDefaults.$searchSettings
            .eraseToEffect()
    }
    
    var dictionarySettingsPublisher: Effect<PersonalDictionarySettings, Never> {
        UserDefaults.$personalDictionarySettings
            .eraseToEffect()
    }
    
    var recentSearchesPublisher: Effect<[String], Never> {
        UserDefaults.$recentSearches
            .eraseToEffect()
    }
    
    func changeSearchSettings<Value>(_ keyPath: WritableKeyPath<SearchSettings, Value>, newValue: Value) {
        var newSettings = UserDefaults.searchSettings
        newSettings[keyPath: keyPath] = newValue
        if UserDefaults.searchSettings == newSettings { return }
        UserDefaults.searchSettings = newSettings
    }
    
    func changeDictionarySettings<Value>(_ keyPath: WritableKeyPath<PersonalDictionarySettings, Value>, newValue: Value) {
        var newSettings = UserDefaults.personalDictionarySettings
        newSettings[keyPath: keyPath] = newValue
        if UserDefaults.personalDictionarySettings == newSettings { return }
        UserDefaults.personalDictionarySettings = newSettings
    }
    
    func increaseCurrentLearnCount(by amount: Int) {
        var newSettings = UserDefaults.searchSettings
        newSettings.increaseCurrentLearnCount(by: amount)
        UserDefaults.searchSettings = newSettings
    }
    
    func increaseCurrentSearchCount() {
        var newSettings = UserDefaults.searchSettings
        newSettings.increaseCurrentSearchCount()
        UserDefaults.searchSettings = newSettings
    }
    
    func addRecentSearch(_ newSearch: String) {
        var recentSearches = UserDefaults.recentSearches
        if recentSearches.contains(newSearch) { return }
        if recentSearches.count > 4 { recentSearches.removeLast() }
        recentSearches.insert(newSearch, at: 0)
        UserDefaults.recentSearches = recentSearches
    }
    
    
}

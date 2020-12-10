//
//  UserDefaults.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-28.
//

import Foundation

extension UserDefaults {
    
    // MARK: - Search
    
    @UserDefaultPublished("search_settings", defaultValue: SearchSettings.defaultValue)
    static var searchSettings: SearchSettings
    
    @UserDefaultPublished("recent_searches", defaultValue: [])
    static var recentSearches: [String]
    
    
    // MARK: - Dictionary
    
    @UserDefaultPublished("dictionary_settings", defaultValue: PersonalDictionarySettings.defaultValue)
    static var personalDictionarySettings: PersonalDictionarySettings

}

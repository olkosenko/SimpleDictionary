//
//  UserDefaults.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-28.
//

import Foundation

extension UserDefaults {
    
    // MARK: - Search
    
    @UserDefault(key: "recentSearches", defaultValue: [])
    static var recentSearches: [String]
    
    @UserDefault(key: "isSearchGoalActive", defaultValue: true)
    static var isSearchGoalActive: Bool
    
    @UserDefault(key: "isLearnGoalActive", defaultValue: true)
    static var isLearnGoalActive: Bool
    
    @UserDefault(key: "searchGoalCount", defaultValue: 30)
    static var searchGoalCount: Int
    
    @UserDefault(key: "learnGoalCount", defaultValue: 10)
    static var learnGoalCount: Int
    
    
    // MARK: - Vocabulary
    
    @UserDefault(key: "isDictionaryDateShown", defaultValue: false)
    static var isDictionaryDateShown: Bool

}

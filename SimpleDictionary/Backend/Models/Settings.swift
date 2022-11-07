//
//  Settings.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-09.
//

import Foundation

enum SettingsType {
    case search
    case learn
    case dictionary
}

struct SearchSettings: Equatable, Codable {
    var dateActive: Date
    
    var isSearchGoalActive: Bool
    var searchGoalCount: Int
    var currentSearchCount: Int
    
    var isLearnGoalActive: Bool
    var learnGoalCount: Int
    var currentLearnCount: Int
    
    mutating func increaseCurrentSearchCount() { currentSearchCount += 1 }
    mutating func increaseCurrentLearnCount() { currentLearnCount += 1 }
    mutating func increaseCurrentLearnCount(by amount: Int) { currentLearnCount += amount }
    
    static let defaultValue = SearchSettings(dateActive: Date(),
                                             isSearchGoalActive: true,
                                             searchGoalCount: 30,
                                             currentSearchCount: 0,
                                             isLearnGoalActive: true,
                                             learnGoalCount: 30,
                                             currentLearnCount: 0
    )
}

struct LearnSettings: Equatable, Codable {
    
}

struct PersonalDictionarySettings: Equatable, Codable {
    var isDictionaryDateShown: Bool
    
    static let defaultValue = PersonalDictionarySettings(isDictionaryDateShown: false)
}

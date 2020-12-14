//
//  GameTabViewModel.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-13.
//

import SwiftUI

class GameTabViewModel: ObservableObject {
    @Published var gameProcessViewModel: GameViewModel?

    @Published var shouldIncludeLearned = false
    @Published var shouldShuffle = true
    @Published var shouldIncludeWODs = false
    @Published var wordCount = 30.0
    
    var notLearned = 30
    var total = 50
    
    var wordCountRounded: Int {
        print(wordCount)
        return Int(min(wordCount, maxValueSlider))
    }
    
    var maxValueSlider: Double {
        shouldIncludeLearned ? Double(total) : Double(notLearned)
    }
    
    func generateGame() {
        gameProcessViewModel = GameViewModel()
    }
    
}

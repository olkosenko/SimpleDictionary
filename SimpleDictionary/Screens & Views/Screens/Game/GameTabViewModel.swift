//
//  GameTabViewModel.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-13.
//

import SwiftUI
import Combine
import ComposableArchitecture

class GameTabViewModel: ObservableObject {
    
    let gameDataProvider: GameDataProvider
    
    @Published var gameProcessViewModel: GameViewModel?
    @Published var shouldIncludeLearned = false
    @Published var shouldShuffle = true
    @Published var shouldIncludeWODs = false
    @Published var selectedWordCount = 30.0
    @Published var wordCount = 0
    
    private var notLearned: Int {
        return wordsFromDictionary.count
    }
    
    private var wordsFromDictionary = [Word]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(gameDataProvider: GameDataProvider) {
        self.gameDataProvider = gameDataProvider
        
        $selectedWordCount
            .print()
            .sink { count in
                //self.selectedWordCount = count
            }
            .store(in: &cancellables)
        
        gameDataProvider.wordsPublisher
            .replaceError(with: [])
            .sink { words in
                self.wordCount = words.count
                self.wordsFromDictionary = words
            }
            .store(in: &cancellables)
    }
    
    let maxValueSlider: Double = 100
    
    func generateGame() {
        gameProcessViewModel = GameViewModel(
            cards: []
        )
    }
    
}

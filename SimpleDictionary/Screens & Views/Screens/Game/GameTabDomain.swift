//
//  GameTabDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-14.
//

import Foundation
import ComposableArchitecture

struct GameTabState: Equatable {
    var gameProcessViewModel: GameViewModel?
    
    var wordsFromDictionary: [Word] = []
    var wordsWOD: [Word] = []
        
    var alreadyLearnedWordsCount = 0
    
    var shouldShuffle = true
    var shouldIncludeWODs = false
    
    var sliderValue = 0
    var sliderMaxValue: Int {
        var maxValue = wordsFromDictionary.count
        
        if shouldIncludeWODs {
            maxValue += wordsWOD.count
        }
        
        return max(1, maxValue)
    }
}

enum GameTabAction {
    case onAppear
    case dismissCover
    
    case onWordsReceived(Result<[Word], Never>)
    
    case onShuffleToggleChanged(Bool)
    case onIncludeWODsToggleChanged(Bool)
    case onSliderChanged(Double)
    
    case onPlayButtonTapped
}

struct GameTabEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var gameDataProvider: GameDataProvider
    var userDefaultsDataProvider: UserDefaultsDataProvider
}

let gameTabReducer = Reducer<
    GameTabState, GameTabAction, GameTabEnvironment
> { state, action, environment in

    switch action {
    
    case .onAppear:
        return .merge(
            environment.gameDataProvider.wordsPublisher
                .subscribe(on: DispatchQueue.global())
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(GameTabAction.onWordsReceived)
        )
    
    case .onWordsReceived(.success(let words)):
        state.wordsFromDictionary = words.filter { !$0.isWODNormalized }
        state.wordsWOD = words.filter { $0.isWODNormalized }
        
        state.sliderValue = max(state.sliderValue, state.wordsFromDictionary.count)
        
        return .none
        
    case .onShuffleToggleChanged(let isOn):
        state.shouldShuffle = isOn
        return .none
        
    case .onIncludeWODsToggleChanged(let isOn):
        state.shouldIncludeWODs = isOn
        if !isOn {
            state.sliderValue = min(state.sliderValue, state.wordsFromDictionary.count)
        }
        if isOn {
            state.sliderValue = max(state.sliderValue, 1)
        }
        
        return .none
        
    case .onSliderChanged(let newValue):
        state.sliderValue = Int(newValue)
        return .none
        
    case .onPlayButtonTapped:
        var words = state.wordsFromDictionary
        
        if state.shouldIncludeWODs {
            words += state.wordsWOD
        }
        if state.shouldShuffle {
            words.shuffle()
        }
        
        words.removeLast(max(0, words.count - state.sliderValue))
        
        let cards = words.compactMap { word -> GameModel.Card? in
            if !word.normalizedTitle.isBlank,
               let definition = word.normalizedDefinitions.first,
               !definition.normalizedTitle.isBlank {
                return GameModel.Card.init(id: word.normalizedId,
                                    frontText: word.normalizedTitle,
                                    backText: definition.normalizedTitle)
            }
            return nil
        }
        
        state.gameProcessViewModel = .init(cards: cards)
        return .none
        
    case .dismissCover:
        let learnedCount = Int(state.gameProcessViewModel?.learnedCount ?? "0") ?? 0
        state.gameProcessViewModel = nil
        return .fireAndForget {
            environment.userDefaultsDataProvider.increaseCurrentLearnCount(by: learnedCount)
        }
        
    }
    
}

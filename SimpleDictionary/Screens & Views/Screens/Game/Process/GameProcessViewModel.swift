//
//  GameViewModel.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-12.
//

import SwiftUI

class GameViewModel: ObservableObject, Identifiable {
    let id = UUID()
    @Published private var game: GameModel
    @Published var isRulesSheetPresented = false
    
    let orientationChangesPublisher = NotificationCenter.default
        .publisher(for: UIDevice.orientationDidChangeNotification)
    
    init() {
        game = GameModel()
    }
    
    var cards: [GameModel.Card] {
        game.cards
    }
    
    var cardSize: CGSize {
        game.cardSize
    }
    
    var scoreText: String {
        "\(game.playedCount) / \(game.cards.count - 1)"
    }
    
    var shouldShowResults: Bool {
        game.playedCount == game.cards.count - 1
    }
    
    var gameResultsLearnedTitle: String? {
        if game.learnedCount > 0 {
            return "You learned \(game.learnedCount) \(game.learnedCount.sanitizedWord())!"
        } else {
            return nil
        }
    }
    
    var gameResultsPracticeTitle: String {
        if game.learnedCount > 0 {
            return "Keep practicing to master the remaining \(game.repeatCount)"
        } else {
            return "Keep practicing to master \(game.repeatCount) \(game.repeatCount.sanitizedWord())"
        }
    }
    
    var learnedCount: String {
        String(game.learnedCount)
    }
    
    var repeatCount: String {
        String(game.repeatCount)
    }
    
    func appearanceChanged(newSize size: CGSize) {
        game.gameAppearanceChanged(newSize: size)
    }
    
    func topCardLocationChanged(with translation: CGSize) {
        game.topCardLocationChanged(with: translation)
    }
    
    func topCardLocationChangesEnded() {
        game.topCardLocationChangesEnded()
    }
    
    func flipTopCard() {
        game.flipTopCard()
    }
}

fileprivate extension Int {
    func sanitizedWord() -> String {
        self > 1 ? "words" : "word"
    }
}

//
//  GameViewModel.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-12.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published private var game: GameModel
    

    let orientationChangedPublisher = NotificationCenter.default
        .publisher(for: UIDevice.orientationDidChangeNotification)
    
    init() {
        game = GameModel()
    }
    
    var cards: [GameModel.Card] {
        game.cards
    }
    
    var resultsText: String {
        "\(game.playedCount) / \(game.cards.count)"
    }
    
    var gotItCount: String {
        String(game.gotItCount)
    }
    
    var learnAgain: String {
        String(game.learnAgainCount)
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


//
//  GameModel.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-12.
//

import SwiftUI

struct GameModel {
    var cards: [Card] = [
        .init(id: .init(), frontText: "Hi Hi HiHi HiHiHiHiHi Hi", backText: "HiHi м м Hiмv Hi kf kjdfjn fjdg jdsfjk slnjfsdlj nfsdjaz njsfnj dfjzdsn jljr"),
        .init(id: .init(), frontText: "Hello", backText: "Bye"),
        .init(id: .init(), frontText: "Lol", backText: "Che"),
        .init(id: .init(), frontText: "Kek", backText: "Burek"),
        .init(id: .init(), frontText: "Hello", backText: "Bye"),
        .init(id: .init(), frontText: "Lol", backText: "Che"),
        .init(id: .init(), frontText: "Kek", backText: "Burek")
    ]
    
    var cardSize: CGSize = .init(width: 300, height: 300)
    var cardsCenterLocation: CGPoint = .zero
    var leftLimit: CGFloat = -1000
    var rightLimit: CGFloat = 1000
    
    var playedCount = 0
    var learnedCount = 0 {
        willSet {
            playedCount += 1
        }
    }
    var repeatCount = 0 {
        willSet {
            playedCount += 1
        }
    }
    
    init(cards: [Card] = []) {
        let resultsCard = Card(id: .init(), frontText: "", backText: "")
        self.cards.append(resultsCard)
    }

    struct Card: Identifiable, Equatable {
        let id: UUID
        let frontText: String
        let backText: String
        
        var isFaceUp = true
        var currentLocation: CGPoint = .zero
        var rotationAngle: Angle = .zero
        var shadowColor: Color = .clear
        var isBlurred: Bool = true
        var zIndex: Double = 0
        
        var status: GameCardStatus = .absent
    }
    
    mutating func gameAppearanceChanged(newSize size: CGSize) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        cardsCenterLocation = center
        cards.indices.forEach { index in
            cards[index].currentLocation = center
            cards[index].zIndex = Double(cards.count - index)
            cards[index].rotationAngle = Angle(degrees: Double.random(in: -7...7))
        }
        
        cards[safe: 0]?.isBlurred = false
        cards[safe: 0]?.rotationAngle = .zero
        
        leftLimit = size.width / 3
        rightLimit = size.width / 3 * 2
        
        let cardHeight: CGFloat = min(size.height - 150, 300)
        let cardWidth: CGFloat = min(size.width - 100, 300)
        cardSize = CGSize(width: cardWidth, height: cardHeight)
    }
    
    mutating func topCardLocationChanged(with translation: CGSize) {
        guard cards.first != nil else { return }
        
        var newLocation = cardsCenterLocation
        newLocation.x += translation.width
        newLocation.y += translation.height
        let rotationAngle = Angle(degrees: Double(newLocation.x - cardsCenterLocation.x) * 0.05)
        
        var shadowColor: Color
        if newLocation.x < leftLimit {
            shadowColor = .red
            cards[0].status = .learnAgain
        } else if newLocation.x > rightLimit {
            shadowColor = .green
            cards[0].status = .gotIt
        }
        else {
            shadowColor = .clear
            cards[0].status = .absent
        }
        
        cards[0].currentLocation = newLocation
        cards[0].rotationAngle = rotationAngle
        cards[0].shadowColor = shadowColor
    }
    
    mutating func topCardLocationChangesEnded() {
        guard let firstCard = cards.first else { return }

        /// Reset properties of first card in the deck
        cards[0].currentLocation = cardsCenterLocation
        cards[0].shadowColor = .clear
        cards[0].status = .absent
        cards[0].rotationAngle = Angle(degrees: 0)
        
        if firstCard.currentLocation.x < leftLimit || firstCard.currentLocation.x > rightLimit {
            if let lastCardZIndex = cards.last?.zIndex {
                cards.indices.forEach { cards[$0].zIndex += 1 }
                cards[0].zIndex = lastCardZIndex
            }
            cards.move(fromOffsets: .init(integer: 0), toOffset: cards.count)
            
            cards[cards.count - 1].isBlurred = true
            cards[cards.count - 1].rotationAngle = Angle(degrees: Double.random(in: -7...7))
            
            cards[0].isBlurred = false
            cards[0].rotationAngle = Angle(degrees: 0)
            
            if firstCard.currentLocation.x < leftLimit { repeatCount += 1 } else { learnedCount += 1 }
        }
    }
    
    mutating func flipTopCard() {
        guard cards.first != nil else { return }
        cards[0].isFaceUp.toggle()
    }
}

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
        .init(id: .init(), frontText: "Bye", backText: "Bye"),
        .init(id: .init(), frontText: "Hey", backText: "Bye"),
        .init(id: .init(), frontText: "Sd", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),.init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),.init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),.init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye"),
        .init(id: .init(), frontText: "sfdfHi", backText: "Bye")
    ]
    
    var playedCount = 0
    var gotItCount = 0 {
        willSet {
            playedCount += 1
        }
    }
    var learnAgainCount = 0 {
        willSet {
            playedCount += 1
        }
    }
    
    var cardsCenterLocation: CGPoint = .zero
    var leftLimit: CGFloat = -1000
    var rightLimit: CGFloat = 1000

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
            if index != 0 {
                cards[index].rotationAngle = Angle(degrees: Double.random(in: -10...10))
            } else {
                cards[index].isBlurred = false
            }
        }
        
        leftLimit = size.width / 3
        rightLimit = size.width / 3 * 2
    }
    
    mutating func topCardLocationChanged(with translation: CGSize) {
        guard cards.first != nil else { return }
        
        var newLocation = cardsCenterLocation
        newLocation.x += translation.width
        newLocation.y += translation.height
        let rotationAngle = Angle(degrees: Double(newLocation.x - cardsCenterLocation.x) * 0.05)
        
        var shadowColor: Color = .clear
        if newLocation.x < leftLimit {
            shadowColor = .red
            cards[0].status = .learnAgain
        } else if newLocation.x > rightLimit {
            shadowColor = .green
            cards[0].status = .gotIt
        }
        else {
            cards[0].status = .absent
        }
        
        cards[0].currentLocation = newLocation
        cards[0].rotationAngle = rotationAngle
        cards[0].shadowColor = shadowColor
    }
    
    mutating func topCardLocationChangesEnded() {
        guard let firstCard = cards.first else { return }

        cards[0].currentLocation = cardsCenterLocation
        cards[0].shadowColor = .clear
        cards[0].status = .absent
        
        if firstCard.currentLocation.x < leftLimit {
            if let lastCardZIndex = cards.last?.zIndex {
                cards.indices.forEach { cards[$0].zIndex += 1 }
                cards[0].zIndex = lastCardZIndex
            }
            cards.move(fromOffsets: .init(integer: 0), toOffset: cards.count)
            cards[cards.count - 1].rotationAngle = Angle(degrees: Double.random(in: -10...10))
            cards[cards.count - 1].isBlurred = true
            cards[0].isBlurred = false
            learnAgainCount += 1
            
        } else if firstCard.currentLocation.x > rightLimit {
            if let lastCardZIndex = cards.last?.zIndex {
                cards.indices.forEach { cards[$0].zIndex += 1 }
                cards[0].zIndex = lastCardZIndex
            }
            cards.move(fromOffsets: .init(integer: 0), toOffset: cards.count)
            cards[cards.count - 1].rotationAngle = Angle(degrees: Double.random(in: -10...10))
            cards[cards.count - 1].isBlurred = true
            cards[0].isBlurred = false
            gotItCount += 1
            
        }
        
        cards[0].rotationAngle = Angle(degrees: 0)
    }
    
    mutating func flipTopCard() {
        guard cards.first != nil else { return }
        cards[0].isFaceUp.toggle()
    }
    
}

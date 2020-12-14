//
//  Cardify.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-10.
//

import SwiftUI

enum GameCardStatus {
    case absent
    case learnAgain
    case gotIt
}

struct GameCardView<FrontContent: View, BackContent: View>: View {
    
    private let frontContent: FrontContent
    private let backContent: BackContent
    private let status: GameCardStatus
    
    private var rotation: Double
    private var isFaceUp: Bool {
        rotation < 90
    }
    
    init(isFaceUp: Bool,
         status: GameCardStatus,
         @ViewBuilder frontContent: () -> FrontContent,
         @ViewBuilder backContent: () -> BackContent) {
        self.rotation = isFaceUp ? 0 : 180
        self.status = status
        self.frontContent = frontContent()
        self.backContent = backContent()
    }
    
    var body: some View {
        ZStack {
            Group {
                cardOutline
                frontContent
            }
            .opacity(isFaceUp ? 1 : 0)
            
            Group {
                cardOutline
                backContent
                    .rotation3DEffect(
                        Angle.degrees(180),
                        axis: (0, 1, 0)
                    )
            }
            .opacity(isFaceUp ? 0 : 1)
            
            topBar
        }
        .rotation3DEffect(
            Angle.degrees(rotation),
            axis: (0, 1, 0)
        )
    }
    
    private var cardOutline: some View {
        Group {
            RoundedRectangle(cornerRadius: 20).fill(Color.white)
                .shadow(color: .black, radius: 4, x: 0, y: 0)
            RoundedRectangle(cornerRadius: 20).stroke()
        }
    }
    
    private var topBar: some View {
        VStack {
            switch status {
            case .absent:
                EmptyView()
                
            case .gotIt:
                gotIt
                
            case .learnAgain:
                learnAgain
            }
            Spacer()
        }
        .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
        .rotation3DEffect(
            Angle.degrees(isFaceUp ? 0 : 180),
            axis: (0, 1, 0)
        )
    }
    
    private var gotIt: some View {
        HStack {
            Spacer()
            Text("Got it")
            Spacer()
        }
        .frame(height: 40)
        .background(Color.green)
        .clipped()
    }
    
    private var learnAgain: some View {
        HStack {
            Spacer()
            Text("Learn again")
            Spacer()
        }
        .frame(height: 40)
        .background(Color.red)
        .clipped()
    }
    
}

struct GameCardView_Previews: PreviewProvider {
    static var previews: some View {
        GameCardView(
            isFaceUp: true,
            status: .gotIt,
            frontContent: { Text("Hello") },
            backContent: { Text("Hello") }
        )
        .padding()
    }
}

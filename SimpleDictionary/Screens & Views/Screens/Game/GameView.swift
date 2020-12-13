//
//  GameView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import SwiftUI
import ComposableArchitecture

struct GameView: View {
    @StateObject var viewModel: GameViewModel
    
    func dragGesture() -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                withAnimation {
                    viewModel.topCardLocationChanged(with: value.translation)
                }
            }
            .onEnded { _ in
                withAnimation(.linear(duration: 0.3)) {
                    viewModel.topCardLocationChangesEnded()
                }
            }
    }
    
    func tapGesture() -> some Gesture {
        TapGesture()
            .onEnded {
                withAnimation(Animation.linear(duration: 0.25)) {
                    viewModel.flipTopCard()
                }
            }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                deck
                
                VStack {
                    HStack {
                        Text(viewModel.resultsText)
                            .font(.system(.body, design: .monospaced))
                    }
                    
                    Spacer()
                    
                    HStack {
                        label(text: viewModel.learnAgain, color: .red)
                        Spacer()
                        label(text: viewModel.gotItCount, color: .green)
                    }
                    .padding()
                }
            }
            .onAppear {
                viewModel.appearanceChanged(newSize: proxy.size)
            }
            .onReceive(viewModel.orientationChangedPublisher) { _ in
                viewModel.appearanceChanged(newSize: proxy.size)
            }
        }
    }
    
    private var deck: some View {
        ForEach(viewModel.cards) { card in
            GameCardView(isFaceUp: card.isFaceUp, status: card.status) {
                Text(card.frontText)
                    .blur(radius: card.isBlurred ? 3.0 : 0)
            } backContent: {
                Text(card.backText)
                    .blur(radius: card.isBlurred ? 3.0 : 0)
            }
            .frame(width: 300, height: 300)
            .shadow(color: card.shadowColor, radius: 40, x: 0, y: 0)
            .position(card.currentLocation)
            .zIndex(card.zIndex)
            .gesture(tapGesture())
            .gesture(dragGesture())
            .rotationEffect(card.rotationAngle)
        }
    }
    
    private func label(text: String, color: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(color)
            Text(text)
                .bold()
                .font(.system(.body, design: .monospaced))
        }
        .frame(width: 60, height: 40)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameViewModel())
    }
}


//withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1)) {
//    cardCurrentLocation = cardCenter
//}

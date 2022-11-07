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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                deck
                    .disabled(viewModel.shouldShowResults)
                
                if viewModel.shouldShowResults {
                    resultsCard
                        .zIndex(1000)
                }
                
                VStack {
                    topBar
                    
                    Spacer()
                    
                    bottomBar
                }
            }
            .onAppear {
                viewModel.appearanceChanged(newSize: proxy.size)
            }
            .onReceive(viewModel.orientationChangesPublisher) { _ in
                viewModel.appearanceChanged(newSize: proxy.size)
            }
            .sheet(isPresented: $viewModel.isRulesSheetPresented) {
                GameRulesHelpView()
            }
        }
    }
    
    private var topBar: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Text(viewModel.scoreText)
                .font(.system(.body, design: .monospaced))
            
            Spacer()
            
            Button {
                viewModel.isRulesSheetPresented.toggle()
            } label: {
                Image(systemName: "info.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
    
    private var deck: some View {
        ForEach(viewModel.cards) { card in
            GameCardView(isFaceUp: card.isFaceUp, status: card.status) {
                Text(card.frontText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .blur(radius: card.isBlurred ? 3.0 : 0)
            } backContent: {
                Text(card.backText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .blur(radius: card.isBlurred ? 3.0 : 0)
            }
            .frame(
                width: viewModel.cardSize.width,
                height: viewModel.cardSize.height
            )
            .shadow(color: card.shadowColor, radius: 40, x: 0, y: 0)
            .position(card.currentLocation)
            .zIndex(card.zIndex)
            .gesture(tapGesture())
            .gesture(dragGesture())
            .rotationEffect(card.rotationAngle)
        }
    }
    
    private var bottomBar: some View {
        HStack {
            label(text: viewModel.repeatCount, color: .red)
            Spacer()
            label(text: viewModel.learnedCount, color: .green)
        }
        .padding()
    }
    
    private var resultsCard: some View {
        GameResultsCard(
            dismissAction: { presentationMode.wrappedValue.dismiss() },
            learnedTitle: viewModel.gameResultsLearnedTitle,
            practiceTitle: viewModel.gameResultsPracticeTitle
        )
        .frame(
            width: viewModel.cardSize.width,
            height: viewModel.cardSize.height
        )
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
    
    private func dragGesture() -> some Gesture {
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
    
    private func tapGesture() -> some Gesture {
        TapGesture()
            .onEnded {
                withAnimation(Animation.linear(duration: 0.25)) {
                    viewModel.flipTopCard()
                }
            }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameViewModel(cards: []))
    }
}

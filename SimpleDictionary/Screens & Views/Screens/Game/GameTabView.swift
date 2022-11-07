//
//  GameTabView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-13.
//

import SwiftUI
import ComposableArchitecture

struct GameTabView: View {
    typealias ViewStoreType = ViewStore<GameTabState, GameTabAction>
    let store: Store<GameTabState, GameTabAction>
    
    private let titleGradient = LinearGradient(
        gradient: .init(colors: [.red, .blue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    private let subtitleGradient = LinearGradient(
        gradient: .init(colors: [.blue, .red]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    private let buttonGradient = LinearGradient(
        gradient: .init(colors: [Color.red.opacity(0.8),
                                 Color.red.opacity(1),
                                 Color.red.opacity(0.8)]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    
                    topBar
                    
                    Divider()
                    
                    HStack {
                        Spacer()
                        GameRulesView()
                        Spacer()
                    }
                    
                    Divider()
                    
                    settingsForm(viewStore)
                        .padding(.horizontal)
                    
                    playButton(viewStore)
                        .padding(.bottom)
                }
            }
            .fullScreenCover(item: viewStore.binding(get: { $0.gameProcessViewModel },
                                                     send: GameTabAction.dismissCover)) {
                GameView(viewModel: $0)
            }
            .onAppear { viewStore.send(.onAppear) }
        }
    }
    
    private var topBar: some View {
        VStack(spacing: 0) {
            Text("Flashcards")
                .font(.largeTitle)
                .gradientForeground(gradient: titleGradient)

            Text("Practice words from your dictionary")
                .multilineTextAlignment(.center)
                .gradientForeground(gradient: subtitleGradient)
        }
    }
    
    private func settingsForm(_ viewStore: ViewStoreType) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text("Settings")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                Spacer()
            }
            
            VStack(spacing: 0) {
                
                Toggle(
                    "Shuffle words",
                    isOn: viewStore.binding(
                        get: { $0.shouldShuffle },
                        send: GameTabAction.onShuffleToggleChanged
                    )
                )
                .frame(height: 50)
                
                Divider()
                
                Toggle(
                    "Include Words of the Day",
                    isOn: viewStore.binding(
                        get: { $0.shouldIncludeWODs },
                        send: GameTabAction.onIncludeWODsToggleChanged
                    )
                )
                .frame(height: 50)
                
                Divider()
                
                numberOfWordsSlider(viewStore)
                    .frame(height: 50)
                
            }
            .padding(.horizontal)
            .background(Color.appBackground)
            .cornerRadius(10)
        }
    }
    
    private func numberOfWordsSlider(_ viewStore: ViewStoreType) -> some View {
        HStack(spacing: 4) {
            Text("Count:")
            
            Text("\(viewStore.sliderValue)")
                .font(.system(.body, design: .monospaced))
                .padding(.trailing)
            
            if viewStore.sliderMaxValue > 1 {
                Slider(
                    value: viewStore.binding(
                        get: { Double($0.sliderValue) },
                        send: GameTabAction.onSliderChanged
                    ),
                    in: 1...Double(viewStore.sliderMaxValue),
                    minimumValueLabel: Text("1"),
                    maximumValueLabel: Text("\(viewStore.sliderMaxValue)"),
                    label: { EmptyView() }
                )
            } else {
                Spacer()
            }
        }
    }
    
    private func playButton(_ viewStore: ViewStoreType) -> some View {
        Button {
            viewStore.send(.onPlayButtonTapped)
        } label: {
            RoundedRectangle(cornerRadius: 20)
                .fill(buttonGradient)
                .overlay(
                    Text("Play")
                        .foregroundColor(.white)
                )
        }
        .shadow(radius: 8)
        .frame(width: 100, height: 40)
        .buttonStyle(PlainButtonStyle())
    }

}

fileprivate extension View {
    func gradientForeground(gradient: LinearGradient) -> some View {
        self.overlay(gradient)
            .mask(self)
    }
}

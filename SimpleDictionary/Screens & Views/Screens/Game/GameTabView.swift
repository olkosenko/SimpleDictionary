//
//  GameTabView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-13.
//

import SwiftUI

struct GameTabView: View {
    @StateObject var viewModel: GameTabViewModel
    
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
                
                settingsForm
                    .padding(.horizontal)
                
                playButton
                    .padding(.bottom)
            }
        }
        .fullScreenCover(item: $viewModel.gameProcessViewModel) {
            GameView(viewModel: $0)
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
    
    private var settingsForm: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Settings")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                Spacer()
            }
            
            VStack(spacing: 0) {

                Toggle("Include already learned", isOn: $viewModel.shouldIncludeLearned)
                    .frame(height: 50)
                
                Divider()
                    
                Toggle("Shuffle words", isOn: $viewModel.shouldShuffle)
                    .frame(height: 50)
                
                Divider()
                
                Toggle("Include Words of the Day", isOn: $viewModel.shouldIncludeWODs)
                    .frame(height: 50)
                
                Divider()
                
                numberOfWordsCell
                    .frame(height: 50)
                
            }
            .padding(.horizontal)
            .background(Color.appBackground)
            .cornerRadius(10)
        }
    }
    
    private var numberOfWordsCell: some View {
        HStack(spacing: 4) {
            Text("Count:")
            
            Text("\(viewModel.wordCountRounded)")
                .font(.system(.body, design: .monospaced))
                .padding(.trailing)
            
            Slider(
                value: $viewModel.wordCount,
                in: 1...viewModel.maxValueSlider,
                minimumValueLabel: Text("1"),
                maximumValueLabel: Text("\(Int(viewModel.maxValueSlider))"),
                label: { Text("Hello: \(viewModel.wordCount)") }
            )
        }
    }
    
    private var playButton: some View {
        Button(action: viewModel.generateGame) {
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

struct GameTabView_Previews: PreviewProvider {
    static var previews: some View {
        GameTabView(viewModel: GameTabViewModel())
    }
}

extension View {
    public func gradientForeground(gradient: LinearGradient) -> some View {
        self.overlay(gradient)
            .mask(self)
    }
}

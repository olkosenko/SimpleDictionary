//
//  GameResultsCard.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-13.
//

import SwiftUI

struct GameResultsCard: View {
    
    let dismissAction: () -> Void
    
    let learnedTitle: String?
    let practiceTitle: String
    
    var body: some View {
        GameCardView(isFaceUp: true, status: .absent) {
            VStack(spacing: 8) {
                Spacer()
                
                if learnedTitle != nil {
                    successView
                } else {
                    failureView
                }
                
                Spacer()
                
                buttonsBar

                Spacer()
            }
        } backContent: {}
    }
    
    var successView: some View {
        Group {
            Text("😎")
                .font(.largeTitle)
            Text("Good job!")
                .font(.title)
            Group {
                Text(learnedTitle!)
                Text(practiceTitle)
            }
            .font(.footnote)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }
    }
    
    var failureView: some View {
        Group {
            Text("😉")
                .font(.largeTitle)
            Text("No worries!")
                .font(.title)
            Group {
                Text(practiceTitle)
            }
            .font(.footnote)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }
    }
    
    var buttonsBar: some View {
        HStack {
            Button(action: dismissAction) {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 100, height: 40)
                    .foregroundColor(.blue)
                    .overlay(Text("Got It").foregroundColor(.white))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

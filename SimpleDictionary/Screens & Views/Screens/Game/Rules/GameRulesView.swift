//
//  GameRulesView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-13.
//

import SwiftUI

struct GameRulesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 60) {
            tapCardRow
            swipeLeftRow
            swipeRightRow
        }
        .frame(width: 300, height: 280)
    }
    
    private var tapCardRow: some View {
        HStack(spacing: 60) {
            ZStack {
                ForEach(1..<4) { index in
                    card {
                        EmptyView()
                    }
                    .offset(x: 0, y: CGFloat(8 - index * 2))
                }

                card(color: .blue) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
            
            VStack(alignment: .leading) {
                Text("Tap the card")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("View the definition")
                    .font(.subheadline)
            }
        }
    }
    
    private var swipeLeftRow: some View {
        HStack(spacing: 60) {
            ZStack {
                ForEach(1..<4) { index in
                    card {
                        EmptyView()
                    }
                    .offset(x: 0, y: CGFloat(8 - index * 2))
                }

                card(color: .red) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                .rotationEffect(Angle(degrees: -20))
                .offset(x: -10, y: 0)
            }
            
            VStack(alignment: .leading) {
                Text("Swipe left")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Continue studying the word")
                    .font(.subheadline)
            }
        }
    }
    
    private var swipeRightRow: some View {
        HStack(spacing: 60) {
            ZStack {
                ForEach(1..<4) { index in
                    card {
                        EmptyView()
                    }
                    .offset(x: 0, y: CGFloat(8 - index * 2))
                }

                card(color: .green) {
                    Image(systemName: "arrow.uturn.forward")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                .rotationEffect(Angle(degrees: 20))
                .offset(x: 10, y: 0)
            }
            
            VStack(alignment: .leading) {
                Text("Swipe right")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Mark the word as known")
                    .font(.subheadline)
            }
        }
    }
    
    private func card<Content: View>(color: Color = .white,
                                     with overlay: () -> Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(color)
                .shadow(radius: 4)
                .frame(width: 30, height: 45)
            
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.white)
                .frame(width: 30, height: 45)
        }
        .shadow(radius: 4)
        .overlay(
            overlay()
        )
    }
}

struct GameRulesView_Previews: PreviewProvider {
    static var previews: some View {
        GameRulesView()
            .previewLayout(.fixed(width: 400, height: 500))
    }
}

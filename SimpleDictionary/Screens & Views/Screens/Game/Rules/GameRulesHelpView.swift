//
//  GameRulesHelpView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-13.
//

import SwiftUI

struct GameRulesHelpView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 30) {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.down")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                Spacer()
                
                Text("Game Tips")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                GameRulesView()
                
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue)
                        .overlay(
                            Text("Continue")
                                .foregroundColor(.white)
                        )
                }
                .shadow(radius: 8)
                .frame(width: 120, height: 40)
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
        }
    }
}

struct GameRulesHelpView_Previews: PreviewProvider {
    static var previews: some View {
        GameRulesHelpView()
    }
}

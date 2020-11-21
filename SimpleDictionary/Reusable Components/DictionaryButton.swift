//
//  DictionaryButton.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-18.
//

import SwiftUI

struct DictionaryButton<Content: View>: View {
    let action: () -> Void
    let content: Content
    
    init(action: @escaping () -> Void,
         @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(action: action) {
            Rectangle()
                .shadow(radius: 5, x: 0, y: 1)
                .foregroundColor(.blue)
                .overlay(
                    content
                        .foregroundColor(.white)
                        .font(Font.headline.weight(.medium))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DictionaryButton_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryButton(action: {}) {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .font(Font.title3.weight(.medium))
        }
        .cornerRadius(55/2)
        .frame(width: 55, height: 55)
        .previewLayout(.fixed(width: 200, height: 200))
    }
}

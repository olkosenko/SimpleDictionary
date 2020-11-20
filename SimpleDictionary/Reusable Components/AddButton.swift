//
//  AddButton.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-18.
//

import SwiftUI

struct AddButton: View {
    let action: () -> Void
    
    init(action: @escaping () -> Void = { print("Add button pressed")} ) {
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Circle()
                .shadow(radius: 5, x: 0, y: 1)
                .foregroundColor(.blue)
                .overlay(
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(Font.title3.weight(.medium))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton()
            .frame(width: 55, height: 55)
            .previewLayout(.fixed(width: 200, height: 200))
    }
}

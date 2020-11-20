//
//  SaveButton.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-19.
//

import SwiftUI

struct SaveButton: View {
    let action: () -> Void
    
    init(action: @escaping () -> Void = { print("Add button pressed")} ) {
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text("Save")
                .font(Font.title3.weight(.medium))
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 30)
                .background(
                    Capsule()
                        .shadow(radius: 5, x: 0, y: 1)
                        .foregroundColor(.blue)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SaveButton_Previews: PreviewProvider {
    static var previews: some View {
        SaveButton()
            .previewLayout(.fixed(width: 200, height: 200))
    }
}

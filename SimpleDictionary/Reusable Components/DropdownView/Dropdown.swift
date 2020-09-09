//
//  Dropdown.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-08.
//

import SwiftUI

protocol Stylable {
    
}

/// MARK: - View

struct Dropdown: View {
    
    @State var expanded = false
    
    let dropdownHeadlineText: String
    let dropdownItems: Array<String>
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Spacer()
                Text(dropdownHeadlineText)
                Spacer()
                if(!dropdownItems.isEmpty) {
                    Image(systemName: "chevron.down.circle")
                        .rotationEffect(.degrees(expanded ? 180 : 0))
                        .foregroundColor(.purple)
                }
                Spacer()
            }
            .onTapGesture(perform: expandDropdown)
            if expanded {
                ForEach(dropdownItems, id: \.self) { item in
                    DropdownItem(text: item)
                }
            }
        }
        .padding(10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
    
    /// MARK: - Functions
    
    private func expandDropdown() {
        withAnimation() {
            self.expanded.toggle()
        }
    }
}

/// MARK: - Previews

struct Dropdown_Previews: PreviewProvider {
    
    static let array = [
        "Excepteur sint occaecat cupidatat non proident.",
        "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        "Excepteur sint occaecat cupidatat non proident."
    ]
    
    static var previews: some View {
        Group {
            Dropdown(dropdownHeadlineText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                     dropdownItems: array)
                .padding()
                .previewLayout(.fixed(width: 400, height: 400))
        }
    }
}

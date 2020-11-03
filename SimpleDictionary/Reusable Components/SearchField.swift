//
//  SearchField.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-10-25.
//

import SwiftUI
import Combine

struct SearchField: View {
    
    @Binding var searchText: String
    @Binding var isEditing: Bool
    let placeholder: String
    
    var body: some View {
        HStack {
            searchBar
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 5.0)
                            .foregroundColor(Color.gray.opacity(0.2)))
            if isEditing {
                Button {
                    isEditing = false
                } label: {
                    Text("Cancel")
                }
            }
        }
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            ZStack(alignment: .leading) {
                if searchText.isEmpty {
                    Text(placeholder)
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.1)))
                }
                TextField("", text: $searchText) { newValue in
                    isEditing = newValue
                }
                .multilineTextAlignment(.leading)
                
            }
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        return SearchField(searchText: .constant(""),
                          isEditing: .constant(false),
                   placeholder: "Hello")
            .padding()
    }
}

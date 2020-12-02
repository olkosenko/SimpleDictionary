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
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(RoundedRectangle(cornerRadius: 5.0)
                                .foregroundColor(Color.gray.opacity(0.2)))
            if isEditing {
                cancelButton
            }
        }
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            ZStack(alignment: .leading) {
                if searchText.isEmpty {
                    Text(placeholder)
                }
                TextField("", text: $searchText) { newValue in
                    isEditing = newValue
                }
                .padding(.vertical, 8)
                .disableAutocorrection(true)
            }
            
            if !searchText.isEmpty {
                Button {
                    // TODO: - Replace with mutation in reducer
                    searchText = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    var cancelButton: some View {
        Button {
            isEditing = false
            // TODO: - Replace with mutation in reducer
            searchText = ""
            UIApplication.shared.endEditing()
        } label: {
            Text("Cancel")
        }
    }
}

struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchField(searchText: .constant(""),
                    isEditing: .constant(false),
                    placeholder: "Hello")
            .padding()
    }
}


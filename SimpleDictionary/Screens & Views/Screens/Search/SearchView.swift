//
//  SearchView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-28.
//

import SwiftUI

struct SearchView: View {
    
    @State var text = ""
    @State var isEditing = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    SearchField(searchText: $text,
                                isEditing: $isEditing,
                                placeholder: "Enter your word")
                        .padding()
                }
            }
            .navigationTitle("Search")
            .navigationBarHidden(false)
            .navigationBarTitleDisplayMode(isEditing ? .inline : .large)
            .background(Color.appBackground)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

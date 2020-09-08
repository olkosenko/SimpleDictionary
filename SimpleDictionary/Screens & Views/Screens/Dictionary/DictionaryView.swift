//
//  DictionaryView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import SwiftUI

struct DictionaryView: View {
    
    @StateObject var viewModel = DictionaryViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    CustomeTextField(word: $viewModel.searchText)
                        .frame(maxHeight: 40)
                }
                .padding(.init(top: 8, leading: 8, bottom: 0, trailing: 8))
            
                Spacer()
                
                List(viewModel.lexicalEntries ?? []) { lexicalEntry in
                    DictionaryEntryView(lexicalEntry: lexicalEntry)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Hello") { })
        }
    }
}

struct CustomeTextField: View {
    @Binding var word: String
    
    var body: some View {
        ZStack {
            TextField("Enter your word", text: $word)
                .multilineTextAlignment(.center)
                .aspectRatio(contentMode: .fit)
            Capsule().stroke()
        }
    }
    
}

struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
    }
}

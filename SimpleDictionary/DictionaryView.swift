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
        VStack {
            HStack {
                Spacer()
                CustomeTextField(word: $viewModel.searchText)
                    .frame(maxHeight: 40)
                Spacer()
            }
            Spacer()
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

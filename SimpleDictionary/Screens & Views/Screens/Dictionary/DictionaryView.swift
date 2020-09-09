//
//  DictionaryView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import SwiftUI

struct DictionaryView: View {
    
    @StateObject var viewModel = DictionaryViewModel()
    @State var isFocused = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    CustomTextField(word: $viewModel.searchText, isFocused: $isFocused)
                        .frame(maxHeight: 40)
                }
                .padding(.init(top: 8, leading: 20, bottom: 8, trailing: 20))
                
                if isFocused {
                    RecentView()
                } else {
                    ScrollView(.horizontal) {
                        HStack(spacing: 5) {
                            ForEach(0..<4) { _ in
                                CardView()
                            }
                            .frame(width: 300)
                            .padding(.init(top: 4, leading: 20, bottom: 4, trailing: 0))
                        }
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Dictionary")
            // .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RecentView: View {
    
    var body: some View {
        HStack {
            Text("Recent")
                .font(.title)
                .bold()
                .padding(.init(top: 0, leading: 20, bottom: 8, trailing: 0))
            Spacer()
        }
        ForEach(0..<5) { el in
            HStack {
                Text("Hello")
                    .font(.title3)
                    .padding(.leading, 20)
                Spacer()
            }
        }
        .padding(.bottom, 5)
    }
}

struct CustomTextField: View {
    @Binding var word: String
    @Binding var isFocused: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(lineWidth: 0)
                .background(Color.gray.opacity(0.1))
            TextField("Enter your word", text: $word) { editing in
                withAnimation {
                    isFocused = editing
                }
            }
            .multilineTextAlignment(.center)
            .aspectRatio(contentMode: .fit)
        }
    }
    
}

struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
    }
}

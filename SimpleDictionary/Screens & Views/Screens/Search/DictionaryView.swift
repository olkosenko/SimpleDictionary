//
//  DictionaryView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import SwiftUI


struct DictionaryView: View {
    
    @StateObject var viewModel = DictionaryViewModel()
    @State var isEditing = false

    var body: some View {
        NavigationView {
            //ScrollView(isEditing ? .init() : .vertical) {
                VStack(spacing: 0) {
                    
                    SearchField(searchText: $viewModel.searchText,
                                isEditing: $isEditing,
                                placeholder: "Enter your word")
                        .padding([.leading, .trailing])
                    
                    if !isEditing {
                        card
                        ProgressView()
                            .padding([.leading, .trailing])
                    } else {
                        if viewModel.searchText.isEmpty {
                            recentList
                                .padding(.top)
                            
                        } else {
                            list
                                .padding(.top)
                        }
                    }
                    
                    Spacer()
                }
                // .offset(x: 0, y: isEditing ? 0 : 100)
                .navigationBarHidden(isEditing)
                .animation(.easeIn(duration: 0.3))
            //}
        }
    }
    
    var card: some View {
        NavigationLink(destination: SearchResultsView(word: "Test")) {
            if viewModel.wod != nil {
                CardView(wod: viewModel.wod!)
                    .padding([.leading, .trailing])
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(height: 230)
    }
    
    var list: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Search")
                    .font(.title3)
                    .bold()
                    .padding(.leading)
                Spacer()
            }
            List(viewModel.wordSearch, id: \.self) { element in
                NavigationLink(element, destination: SearchResultsView(word: element))
                    .buttonStyle(PlainButtonStyle())
            }
            .listStyle(PlainListStyle())
        }
    }
    
    var recentList: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Recent")
                    .font(.title3)
                    .bold()
                    .padding(.leading)
                Spacer()
            }
            List(viewModel.recentSearches, id: \.self) { element in
                NavigationLink(element, destination: SearchResultsView(word: element))
                    .buttonStyle(PlainButtonStyle())
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

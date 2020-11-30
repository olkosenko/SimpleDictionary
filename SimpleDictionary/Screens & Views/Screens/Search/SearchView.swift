//
//  SearchView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-28.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    typealias ViewStoreType = ViewStore<SearchState, SearchAction>
    let store: Store<SearchState, SearchAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ScrollView(.vertical) {
                    VStack(spacing: 0) {
                        
                        searchField(viewStore)
                            .padding()
                        
                        if !viewStore.isSearchQueryEditing && viewStore.searchQuery.isEmpty {
                            idleState(viewStore)
                        } else {
                            searchState(viewStore)
                        }
                    }
                }
                .onAppear { viewStore.send(.onAppear) }
                .navigationTitle("Search")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    func searchField(_ viewStore: ViewStoreType) -> some View {
        SearchField(
            searchText: viewStore.binding(
                get: { $0.searchQuery },
                send: SearchAction.searchQueryChanged),

            isEditing: viewStore.binding(
                get: { $0.isSearchQueryEditing },
                send: SearchAction.searchQueryEditing),

            placeholder: "Enter your word")
    }
    
    func idleState(_ viewStore: ViewStoreType) -> some View {
        VStack(spacing: 0) {
            if viewStore.wordsOfTheDay.isNotEmpty {
                carousel(viewStore)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
                    .frame(height: 300)
                    .offset(y: -40)
            }
            
            ProgressView()
                .animation(.easeIn)
                .padding()
                .offset(x: 0, y: viewStore.wordsOfTheDay.isNotEmpty ? -50 : 0)
        }
    }
    
    func searchState(_ viewStore: ViewStoreType) -> some View {
        Group {
            if viewStore.searchQuery.isEmpty {
                list(with: viewStore.recentSearches, title: "Recent")
            } else {
                list(with: viewStore.searchSuggestion, title: "Suggestions")
            }
        }
    }
    
    func carousel(_ viewStore: ViewStoreType) -> some View {
        TabView {
            ForEach(viewStore.wordsOfTheDay, id: \.self) { wod in
                CardView(title: wod.title,
                         partOfSpeech: wod.partOfSpeech.rawValue,
                         definition: wod.definition,
                         date: wod.date.wod)
                    .padding(.horizontal)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
    
    func list(with array: [String], title: String) -> some View {
        Group {
            HStack {
                Text(title)
                    .font(.title3)
                    .bold()
                    .padding(.leading)
                Spacer()
            }
            ForEach(array, id: \.self) { element in
                VStack {
                    Text(element)
                    Divider()
                }
                .padding()
//                NavigationLink(element, destination: SearchResultsView(word: element))
//                    .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(store:
                    Store(initialState: SearchState(),
                          reducer: searchReducer,
                          environment: SearchEnvironment(
                            mainQueue: AppEnvironment.debug.mainQueue,
                            searchDataProvider: AppEnvironment.debug.searchDataProvider))
        )
    }
}




//                        TabView {
//                            ForEach(0..<2, id: \.self) { _ in
//                                CardView(title: "Edge",
//                                         partOfSpeech: "noun",
//                                         definition: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Consectetur adipiscing elit. consectetur adipiscing elit. consectetur adipiscing elit.",
//                                         date: Date().wod
//                                )
//                                .padding()
//                            }
//                        }
//                        .frame(height: 300)
//                        .offset(x: 0, y: -40)
//                        .tabViewStyle(PageTabViewStyle())
//                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

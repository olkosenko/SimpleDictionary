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
                .transition(AnyTransition.opacity)
                .animation(.easeOut(duration: 0.3))
                .navigationTitle("Search")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: settingsButton(viewStore))
            }
            .onAppear { viewStore.send(.onAppear) }
        }
    }
    
    private func settingsButton(_ viewStore: ViewStoreType) -> some View {
        Button { viewStore.send(.setSettingsSheet(true))} label: {
            Image(systemName: "gearshape.fill")
                .foregroundColor(.blue)
        }
        .sheet(isPresented: viewStore.binding(get: { $0.isSettingsSheetPresented },
                                              send: SearchAction.setSettingsSheet)) {

            SearchSettingsView(
                store: store.scope(state: { $0.settings },
                                   action: SearchAction.settings))

        }
    }
    
    private func searchField(_ viewStore: ViewStoreType) -> some View {
        SearchField(
            searchText: viewStore.binding(
                get: { $0.searchQuery },
                send: SearchAction.searchQueryChanged),

            isEditing: viewStore.binding(
                get: { $0.isSearchQueryEditing },
                send: SearchAction.searchQueryEditing),

            placeholder: "Enter your word, phrase")
    }
    
    private func idleState(_ viewStore: ViewStoreType) -> some View {
        VStack(spacing: 0) {
            if viewStore.wordsOfTheDay.isNotEmpty {
                carousel(viewStore)
                    .frame(height: 300)
                    .offset(y: -40)
            }
            
            if viewStore.dashboard.settings.isLearnGoalActive || viewStore.dashboard.settings.isSearchGoalActive {
                DashboardView(
                    store:
                        store.scope(
                            state: { $0.dashboard },
                            action: SearchAction.dashboard
                        )
                )
                .frame(height: 200)
                .frame(maxWidth: 400)
                .padding()
                .offset(x: 0, y: viewStore.wordsOfTheDay.isNotEmpty ? -50 : 0)
            }
        }
    }
    
    private func searchState(_ viewStore: ViewStoreType) -> some View {
        Group {
            if viewStore.searchQuery.isEmpty {
                if viewStore.recentSearches.isNotEmpty {
                    list(with: viewStore.recentSearches, title: "Recent", viewStore)
                } else {
                    emptyRecentSearchesState
                }
            } else {
                list(with: viewStore.searchSuggestion, title: "Suggestions", viewStore)
            }
        }
    }
    
    private func carousel(_ viewStore: ViewStoreType) -> some View {
        TabView {
            ForEach(viewStore.wordsOfTheDay, id: \.self) { wod in
                CardView(title: wod.title,
                         partOfSpeech: wod.partOfSpeech.rawValue,
                         definition: wod.definition,
                         date: wod.date.monthDayYearLocal)
                    .padding(.horizontal)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
    
    private func list(with array: [String], title: String, _ viewStore: ViewStoreType) -> some View {
        Group {
            listTitle(with: title)
            
            ForEach(array, id: \.self) { title in
                VStack(spacing: 0) {
                    NavigationLink(
                      destination: IfLetStore(
                        self.store.scope(
                            state: { $0.searchResults }, action: SearchAction.searchResults),
                        then: SearchResultsView.init,
                        else: ActivityIndicator()
                      ),
                      tag: title,
                      selection: viewStore.binding(
                        get: { $0.searchResultsTitle },
                        send: SearchAction.setNavigation
                      )
                    ) {
                        listCell(with: title)
                    }
                    .padding(.bottom, 8)
                    
                    Divider()
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
    }
    
    private func listTitle(with text: String) -> some View {
        HStack {
            Text(text)
                .font(.title3)
                .bold()
                .padding(.leading)
            Spacer()
        }
    }
    
    private func listCell(with title: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Image(systemName: "chevron.forward")
                .font(Font.system(.footnote).bold())
                .foregroundColor(Color.gray.opacity(0.5))
        }
    }
    
    private var emptyRecentSearchesState: some View {
        VStack(spacing: 8) {
            listTitle(with: "Recent")
                .padding(.bottom)
            
            Image(systemName: "plus.magnifyingglass")
                .font(.title)
            
            Text("Your recent queries will appear here")
                .padding(.horizontal)
                .multilineTextAlignment(.center)
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
                            searchDataProvider: AppEnvironment.debug.searchDataProvider,
                            userDefaultsDataProvider: AppEnvironment.debug.userDefaultsDataProvider))
        )
    }
}

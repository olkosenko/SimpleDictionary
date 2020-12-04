//
//  SearchResults.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-10-31.
//

import SwiftUI
import ComposableArchitecture


struct SearchResultsView: View {
    typealias ViewStoreType = ViewStore<SearchResultsState, SearchResultsAction>
    let store: Store<SearchResultsState, SearchResultsAction>
    
    let settings = ["Oxford", "Merriam-Webster", "Urban"]
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    topBar(viewStore)
                    picker(viewStore)
                    SearchResultEntryView()
                    Spacer()
                }
                .navigationTitle(viewStore.word)
                .navigationBarTitleDisplayMode(.large)
                .padding(.horizontal)
            }
            .onAppear { viewStore.send(.onAppear) }
        }
    }
    
    func topBar(_ viewStore: ViewStoreType) -> some View {
        HStack(spacing: 12) {
            Text("[tel-uh-fohn]")
            Button { viewStore.send(.playAudio) } label: {
                Image(systemName: "speaker.wave.3.fill")
            }
            .opacity(viewStore.isAudioAvailable ? 1 : 0)
            Spacer()
        }
        .foregroundColor(.blue)
    }
    
    func picker(_ viewStore: ViewStoreType) -> some View {
        Picker("Select dictionary",
               selection: viewStore.binding(get: { $0.currentTab },
                                            send: SearchResultsAction.selectTab)
        ) {
            ForEach(viewStore.tabs) { tab in
                Text(tab.id)
                    .tag(tab)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchResultsView(
                store: .init(
                    initialState: .init(word: "Hello"),
                    reducer: searchResultsReducer,
                    environment: .init(mainQueue: AppEnvironment.debug.mainQueue,
                                       dataProvider: AppEnvironment.debug.searchDataProvider)
                )
            )
        }
    }
}

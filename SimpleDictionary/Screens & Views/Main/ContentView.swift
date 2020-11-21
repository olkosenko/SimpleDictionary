//
//  ContentView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            TabView {
                DictionaryView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                
                HistoryView()
                    .tabItem {
                        Image(systemName: "gamecontroller.fill")
                        Text("Learn")
                    }
                
                PersonalDictionaryView(
                    store: store.scope(
                        state: { $0.personalDictionary },
                        action: AppAction.personalDictionary
                    )
                )
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Dictionary")
                }
                
            }
        }
    }
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

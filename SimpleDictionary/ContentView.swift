//
//  ContentView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            DictionaryView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Dictionary")
                }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("History")
                }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

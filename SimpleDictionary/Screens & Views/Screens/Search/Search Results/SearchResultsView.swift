//
//  SearchResults.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-10-31.
//

import SwiftUI

struct SearchResultsView: View {
    @State var choice = 0
    var settings = ["Oxford", "Merriem-Webster", "Urban"]
    var word: String
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 16) {
                topBar
                Picker("Options", selection: $choice) {
                    ForEach(0 ..< settings.count) { index in
                        Text(self.settings[index])
                            .tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                SearchResultEntryView()
                Spacer()
            }
            .padding([.leading, .trailing])
        }
        .navigationBarTitle(word)
        .navigationBarBackButtonHidden(false)
    }
    
    var topBar: some View {
        HStack(spacing: 12) {
            Text("[tel-uh-fohn]")
            Image(systemName: "speaker.wave.3.fill")
            Spacer()
        }
        .foregroundColor(.blue)
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchResultsView(word: "Telephone")
        }
    }
}

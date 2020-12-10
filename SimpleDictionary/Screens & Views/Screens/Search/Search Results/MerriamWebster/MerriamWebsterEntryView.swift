//
//  MerriamWebsterEntryView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-05.
//

import SwiftUI
import ComposableArchitecture

struct MerriamWebsterEntryView: View {
    let store: Store<MerriamWebsterEntryState, MerriamWebsterEntryAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if let entry = viewStore.shuffledEntry {
                SearchResultEntryView(standardEntry: entry)
            } else {
                emptyState
            }
        }
    }
    
    var emptyState: some View {
        VStack {
            Spacer()
            Text("We were not able to find definitions for this word")
                .multilineTextAlignment(.center)
                .lineLimit(2)
            Spacer()
        }
    }
}

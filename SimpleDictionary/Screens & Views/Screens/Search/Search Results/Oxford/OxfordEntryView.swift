//
//  OxfordEntryView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-04.
//

import SwiftUI
import ComposableArchitecture

struct OxfordEntryView: View {
    let store: Store<OxfordEntryState, OxfordEntryAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if let entry = viewStore.entry {
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

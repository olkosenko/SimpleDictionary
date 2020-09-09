//
//  DictionaryEntryView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import SwiftUI

struct DictionaryEntryView: View {
    
    var entry: Entry
    
    var body: some View {
        VStack {
            Dropdown(dropdownHeadlineText: entry.definitions[0],
                     dropdownItems: entry.examples)
        }
    }
}

struct DictionaryEntryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryEntryView(entry: staticEntries[0])
    }
}

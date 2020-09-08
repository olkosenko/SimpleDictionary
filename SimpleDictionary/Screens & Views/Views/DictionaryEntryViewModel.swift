//
//  DictionaryEntryViewModel.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import Foundation
import Combine

class DictionaryEntryViewModel: ObservableObject {
    
    @Published private var lexicalEntry: LexicalEntry
    
    var text: String {
        lexicalEntry.entries!.first!.senses!.first!.definitions!.first!
    }
    
    var examples: [String] {
        lexicalEntry.entries!.first!.senses!.first!.examples!.map { $0.text }
    }
    
    init(lexicalEntry: LexicalEntry) {
        self.lexicalEntry = lexicalEntry
    }
    
    
}


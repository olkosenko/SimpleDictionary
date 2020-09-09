//
//  DictionaryViewModel.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import Foundation
import Combine

class DictionaryViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var entries: [Entry]
    
    private var cancellableStore = Set<AnyCancellable>()
    
    init() {
        #if DEBUG
        searchText = "Hello"
        entries = staticEntries
        #else
        entries = []
        #endif
        
        $searchText
            .dropFirst()
            .subscribe(on: DispatchQueue.global())
            .debounce(for: 1, scheduler: DispatchQueue.global())
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                if !text.isEmpty {
                    self?.search(with: text)
                }
            }
            .store(in: &cancellableStore)
    }
    
    private func search(with text: String) {
        OXFRetrieveEntry.fetch(word: text)
            .receive(on: DispatchQueue.main)
            .map { $0.convert() }
            .sink { [weak self] results in
                print(results)
                self?.entries = results
            }
            .store(in: &cancellableStore)
    }
    
}

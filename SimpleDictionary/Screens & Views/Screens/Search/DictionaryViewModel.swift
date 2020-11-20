//
//  DictionaryViewModel.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import Foundation
import UIKit
import Combine

class DictionaryViewModel: ObservableObject {
    
    @Published var searchText = ""
    // @Published var entries: [Entry] = []
    @Published var wod: WordnikWOD?
    @Published var wordSearch = [String]()
    let recentSearches = ["Hello", "Telephone", "Confrontation", "Risky"]
    
    private let textChecker = UITextChecker()
    
    private var cancellableStore = Set<AnyCancellable>()
    
    init() {
        $searchText
            .dropFirst()
            .subscribe(on: DispatchQueue.global())
            .debounce(for: 0.1, scheduler: DispatchQueue.global())
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                if !text.isEmpty {
                    self?.search(with: text)
                } else {
                    self?.wordSearch.removeAll()
                }
            }
            .store(in: &cancellableStore)
        
//        WordnikWOD.fetch(for: Calendar.current.date(byAdding: .day, value: 0, to: Date())!)
//            .receive(on: DispatchQueue.main)
//            .sink { fetchedWOD in
//                self.wod = fetchedWOD
//                print(fetchedWOD)
//            }
//            .store(in: &cancellableStore)
    }
    
    private func search(with text: String) {
        let targetText = String(text.split(separator: " ").last!)
        let range = NSRange(targetText.startIndex..<targetText.endIndex, in: targetText)
        let completions = textChecker.completions(forPartialWordRange: range, in: targetText, language: "en")
        var result = completions ?? []
        if result.isEmpty {
            let guesses = textChecker.guesses(forWordRange: range, in: targetText, language: "en")
            result.append(contentsOf: guesses ?? [])
        }
        wordSearch = result
    }
    
}

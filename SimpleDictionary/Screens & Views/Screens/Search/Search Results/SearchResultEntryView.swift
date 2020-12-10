//
//  SearchResultEntryView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-01.
//

import SwiftUI

struct SearchResultEntryView: View {
    let standardEntry: StandardDictionaryEntry
    
    private let columns: [GridItem] = [
        .init(.flexible()),
        .init(.flexible())
    ]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 16) {

                ForEach(standardEntry.entries, id: \.self) { entry in
                    VStack(spacing: 16) {
                        
                        HStack {
                            Text(entry.partOfSpeech.rawValue.capitalized)
                                .bold()
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        
                        definitions(with: entry.definitions)
                        
                        if entry.synonyms.isNotEmpty {
                            synonyms(with: entry.synonyms)
                        }
                        
                        if entry.examples.isNotEmpty {
                            examples(with: entry.examples)
                        }
                        
                        Divider()
                            .padding(.top, 8)
                    }
                }
                
                if standardEntry.etymologies.isNotEmpty {
                    etymologies
                }
            }
        }
    }
    
    private func definitions(with items: [String]) -> some View {
        VStack(spacing: 8) {
            
            HStack(alignment: .center) {
                Text("Definitions")
                    .font(.headline)
                if items.count > 1 {
                    Text("\(items.count)")
                        .font(.subheadline)
                }
                Spacer()
            }
            
            ForEach(Array(zip(items.indices, items)), id: \.0) { index, item in
                HStack(spacing: 0) {
                    let indexAdjusted = index + 1
                    Text("\(indexAdjusted)")
                        .bold()
                        .padding(.trailing)
                    Text(item)
                    Spacer(minLength: 0)
                }
            }
        }
    }
    
    private func synonyms(with items: [String]) -> some View {
        VStack(alignment: .center, spacing: 8) {
            HStack(alignment: .center) {
                Text("Synonyms")
                    .font(.headline)
                if items.count > 1 {
                    Text("\(items.count)")
                        .font(.subheadline)
                }
                Spacer()
            }
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .foregroundColor(.blue)
                        .lineLimit(1)
                }
            }
        }
    }
    
    private func examples(with items: [String]) -> some View {
        VStack(spacing: 8) {
            HStack(alignment: .center) {
                Text("Examples")
                    .font(.headline)
                if items.count > 1 {
                    Text("\(items.count)")
                        .font(.subheadline)
                }
                Spacer()
            }
            ForEach(items, id: \.self) { item in
                HStack(alignment: .center) {
                    Text("// \(item.capitalizeFirst())")
                        .italic()
                    Spacer(minLength: 0)
                }
            }
        }
    }
    
    private var etymologies: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center) {
                Text("Etymologies")
                    .font(.headline)
                if standardEntry.etymologies.count > 1 {
                    Text("\(standardEntry.etymologies.count)")
                        .font(.subheadline)
                }
                Spacer()
            }
            ForEach(standardEntry.etymologies, id: \.self) { etymology in
                HStack {
                    Text(etymology)
                    Spacer(minLength: 0)
                }
            }
        }
    }
    
}

struct SearchResultEntryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultEntryView(
            standardEntry: StandardDictionaryEntry.standardDictionaryTestEntry
        )
        .padding()
    }
}

//
//  SearchResultEntryView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-01.
//

import SwiftUI

struct SearchResultEntryView: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 16) {

                definitions

                Divider()

                HStack(spacing: 120) {
                    synant(word: "Synonyms")
                    synant(word: "Antonyms")
                }

                Divider()

                examples

                Divider()

                etymology
            }
        }
    }
    
    var definitions: some View {
        VStack(spacing: 8) {
            
            HStack(alignment: .center) {
                Text("Definitions")
                    .font(.headline)
                Text("3")
                    .font(.subheadline)
                Spacer()
            }
            
            ForEach(1..<4) { index in
                HStack(spacing: 0) {
                    Text("\(index)")
                        .bold()
                    Spacer(minLength: 10)
                    Text("an apparatus, system, or process for transmission of sound or speech to a distant point, especially by an electric device.")
                }
            }
        }
    }
    
    func synant(word: String) -> some View {
        VStack(alignment: .center, spacing: 8) {
            HStack(alignment: .center) {
                Text(word)
                    .font(.headline)
                Text("4")
                    .font(.subheadline)
            }
            ForEach(0..<4) { _ in
                Text("broadcast")
                    .foregroundColor(.blue)
            }
        }
    }
    
    var examples: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center) {
                Text("Examples")
                    .font(.headline)
                Text("3")
                    .font(.subheadline)
                Spacer()
            }
            ForEach(0..<3) { _ in
                HStack(alignment: .center) {
                    Text("\"An apparatus, system, or process for transmission of sound or speech to a distant point, especially by an electric device.\"")
                }
            }
        }
    }
    
    var etymology: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center) {
                Text("Etymology")
                    .font(.headline)
                Spacer()
            }
            Text("An apparatus, system, or process for transmission of sound or speech to a distant point, especially by an electric device.")
        }
    }
    
}

struct SearchResultEntryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultEntryView()
            .padding()
    }
}

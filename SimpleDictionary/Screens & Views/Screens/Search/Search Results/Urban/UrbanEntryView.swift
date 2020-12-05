//
//  UrbanEntryView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-03.
//

import SwiftUI
import ComposableArchitecture

struct UrbanEntryView: View {
    typealias ViewStoreType = ViewStore<UrbanEntryState, UrbanEntryAction>
    let store: Store<UrbanEntryState, UrbanEntryAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                ForEach(viewStore.state.urbanEntry.list, id: \.self) { definition in
                    entry(with: definition)
                        .padding()
                    Divider()
                        .padding(.horizontal)
                }
            }
        }
    }
    
    func entry(with definition: UrbanEntry.Definition) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text(definition.definition)
                Spacer(minLength: 0)
            }
            
            HStack {
                Text(definition.example)
                    .italic()
                Spacer(minLength: 0)
            }
            
            HStack {
                Text("By: \(definition.author)")
                    .bold()
                Spacer()
                
                if let url = definition.permalink {
                    Link(destination: url) {
                        Image(systemName: "link.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            HStack {
                Image(systemName: "hand.thumbsup.fill")
                Text("\(definition.thumbsUp)")
                    .padding(.trailing, 4)
                
                Image(systemName: "hand.thumbsdown.fill")
                Text("\(definition.thumbsDown)")
                
                Spacer(minLength: 0)
                
                Text(definition.writtenOn?.monthDayYearLocal ?? "Date undefined")
                    .bold()
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
    }
}

//
//struct UrbanEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        UrbanEntryView()
//    }
//}

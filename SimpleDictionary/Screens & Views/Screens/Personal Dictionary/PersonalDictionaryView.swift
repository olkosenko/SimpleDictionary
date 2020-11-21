//
//  PersonalDictionaryView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-18.
//

import SwiftUI
import ComposableArchitecture

struct PersonalDictionaryView: View {
    typealias ViewStoreType = ViewStore<PersonalDictionaryState, PersonalDictionaryAction>
    let store: Store<PersonalDictionaryState, PersonalDictionaryAction>
    
    private enum Const {
        static let buttonSize: CGFloat = 55
        static var buttonCornerRadius: CGFloat { buttonSize / 2 }
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            GeometryReader { proxy in
                ZStack {
                    form(viewStore)
                    addWordButton(in: proxy.size, viewStore)
                }
            }
            .onAppear { viewStore.send(.onAppear) }
        }
    }
    
    private func form(_ viewStore: ViewStoreType) -> some View {
        NavigationView {
            Form {
                ForEach(viewStore.words, id: \.self) { word in
                    NavigationLink(destination: Text("\(word.title!)")) {
                        Text(word.title!)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .onDelete { viewStore.send(.removeWord($0)) }
            }
            .sheet(isPresented: viewStore.binding(get: { $0.isSheetPresented },
                                                  send: PersonalDictionaryAction.setSheet)) {
                
                ManualWordCreationView(
                    store: store.scope(state: { $0.wordCreation },
                                       action: PersonalDictionaryAction.wordCreation))
                
            }
            .navigationTitle("Dictionary")
        }
    }
    
    private func addWordButton(in size: CGSize, _ viewStore: ViewStoreType) -> some View {
        DictionaryButton(action: { viewStore.send(.setSheet(true)) }) {
            Image(systemName: "plus")
        }
        .cornerRadius(Const.buttonCornerRadius)
        .frame(width: Const.buttonSize, height: Const.buttonSize)
        .offset(buttonOffset(in: size))
    }
    
    private func buttonOffset(in size: CGSize) -> CGSize {
        let bottomPadding: CGFloat = 10
        let trailingPadding: CGFloat = 20
        
        let heightOffset = size.height / 2 - Const.buttonSize / 2 - bottomPadding
        let widthOffset = size.width / 2 - Const.buttonSize / 2 - trailingPadding
        
        return CGSize(width: widthOffset, height: heightOffset)
    }
    
}

//struct PersonalDictionaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonalDictionaryView()
//    }
//}

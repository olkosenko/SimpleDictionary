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
        NavigationView {
            WithViewStore(store) { viewStore in
                GeometryReader { proxy in
                    
                    ZStack {
                        form(viewStore)
                        addWordButton(in: proxy.size, viewStore)
                        if viewStore.words.isEmpty {
                            emptyState
                        }
                    }
                    
                }
                .onAppear { viewStore.send(.onAppear) }
                .onDisappear { viewStore.send(.onDisappear) }
            }
            .navigationTitle("Dictionary")
        }
    }
    
    private func form(_ viewStore: ViewStoreType) -> some View {
        Form {
            ForEach(viewStore.words, id: \.self) { word in
                
                NavigationLink(
                    destination: IfLetStore(store.scope(state: { $0.selectionState },
                                           action: PersonalDictionaryAction.wordDetails),
                                          then: WordDetailsView.init,
                                          else: Text("Hello")),
                    tag: word,
                    selection: viewStore.binding(
                        get: { $0.selectionWord },
                        send: PersonalDictionaryAction.setNavigation)) {
                    
                    Text(word.title!)
                    
                }
                .buttonStyle(PlainButtonStyle())
            }
            .onDelete { viewStore.send(.deleteWord($0)) }
        }
        .sheet(isPresented: viewStore.binding(get: { $0.isSheetPresented },
                                              send: PersonalDictionaryAction.setSheet)) {
            
            ManualWordCreationView(
                store: store.scope(state: { $0.wordCreation },
                                   action: PersonalDictionaryAction.wordCreation))
            
        }
    }
    
    private func addWordButton(in size: CGSize, _ viewStore: ViewStoreType) -> some View {
        DictionaryButton(action: { viewStore.send(.setSheet(true)) }) {
            Image(systemName: "plus")
                .font(Font.title2.weight(.medium))
        }
        .cornerRadius(Const.buttonCornerRadius)
        .frame(width: Const.buttonSize, height: Const.buttonSize)
        .offset(buttonOffset(in: size))
    }
    
    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "text.badge.plus")
                .font(.title)
            Text("Your dictionary is empty")
            Text("You can add your words manually or through search")
                .font(.subheadline)
                .foregroundColor(Color.gray.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 60)
        }
    }
    
    private func buttonOffset(in size: CGSize) -> CGSize {
        let bottomPadding: CGFloat = 10
        
        let heightOffset = size.height / 2 - Const.buttonSize / 2 - bottomPadding
        
        return CGSize(width: 0, height: heightOffset)
    }
}

struct PersonalDictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalDictionaryView(store:
            Store(initialState: PersonalDictionaryState(),
                  reducer: personalDictionaryReducer,
                  environment: PersonalDictionaryEnvironment(
                    mainQueue: AppEnvironment.debug.mainQueue,
                    personalDictionaryDataProvider:
                        AppEnvironment.debug.personalDictionaryDataProvider))
            )
    }
}

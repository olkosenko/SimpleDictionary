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
                    
                    if viewStore.isActivityIndicatorVisible {
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                ActivityIndicator()
                                Spacer()
                            }
                            Spacer()
                        }
                    } else {
                        ZStack {
                            form(viewStore)
                            addWordButton(in: proxy.size, viewStore)
                            if viewStore.words.isEmpty {
                                emptyState
                            }
                        }
                    }
                    
                }
                .onAppear { viewStore.send(.onAppear) }
                .onDisappear { viewStore.send(.onDisappear) }
                .navigationBarItems(trailing: settingsButton(viewStore))
            }
            .navigationTitle("Dictionary")
            .background(Color.appBackground)
            .edgesIgnoringSafeArea(.top) /// Makes background color affect status bar
        }
    }
    
    private func settingsButton(_ viewStore: ViewStoreType) -> some View {
        Button { viewStore.send(.setSettingsSheet(true))} label: {
            Image(systemName: "gearshape.fill")
                .foregroundColor(.blue)
        }
        .sheet(isPresented: viewStore.binding(get: { $0.isSettingsSheetPresented },
                                              send: PersonalDictionaryAction.setSettingsSheet)) {

            PersonalDictionarySettingsView(
                store: store.scope(state: { $0.settings },
                                   action: PersonalDictionaryAction.settings))

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
                    
                    Text(word.normalizedTitle)
                    if viewStore.isDictionaryDateShown {
                        Spacer()
                        Text(word.normalizedDate.yearMonthDay)
                            .foregroundColor(.gray)
                    }
                    
                }
                .buttonStyle(PlainButtonStyle())
            }
            .onDelete { viewStore.send(.deleteWord($0)) }
        }
    }
    
    private func addWordButton(in size: CGSize, _ viewStore: ViewStoreType) -> some View {
        DictionaryButton(action: { viewStore.send(.setWordCreationSheet(true)) }) {
            Image(systemName: "plus")
                .font(Font.title2.weight(.medium))
        }
        .cornerRadius(Const.buttonCornerRadius)
        .frame(width: Const.buttonSize, height: Const.buttonSize)
        .offset(buttonOffset(in: size))
        .sheet(isPresented: viewStore.binding(get: { $0.isWordCreationSheetPresented },
                                              send: PersonalDictionaryAction.setWordCreationSheet)) {
            
            ManualWordCreationView(
                store: store.scope(state: { $0.wordCreation },
                                   action: PersonalDictionaryAction.wordCreation))
            
        }
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

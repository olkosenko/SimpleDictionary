//
//  WordDetailsView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-22.
//

import SwiftUI
import ComposableArchitecture

struct WordDetailsView: View {
    typealias ViewStoreType = ViewStore<WordDetailsState, WordDetailsAction>
    let store: Store<WordDetailsState, WordDetailsAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                form(viewStore)
                    .navigationTitle(viewStore.title)
                if viewStore.definitions.isEmpty {
                    emptyState(viewStore)
                }
            }
        }
    }
    
    func form(_ viewStore: ViewStoreType) -> some View {
        Form {
            Section(header: formAddButton(viewStore)) {
                ForEachStore(
                    store.scope(state: { $0.definitions },
                                action: WordDetailsAction.definition),
                    content: EditableDefinitionCellView.init(store:)
                )
                .onDelete { viewStore.send(.removeDefinition($0)) }
            }
        }
    }
    
    func formAddButton(_ viewStore: ViewStoreType) -> some View {
        HStack {
            Text("Definitions")
            Spacer()
            Button(action: { viewStore.send(.addDefinitionButtonTapped) }) {
                Image(systemName: "plus")
                    .foregroundColor(.blue)
                    .font(Font.title3.weight(.medium))
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(viewStore.isAddButtonDisabled)
        }
    }
    
    private func emptyState(_ viewStore: ViewStoreType) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "text.badge.plus")
                .font(.title)
            Text("Your word does not have any definitions")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button("Add Definition") {viewStore.send(.addDefinitionButtonTapped) }
                .foregroundColor(.blue)
        }
    }
}

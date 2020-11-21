//
//  EditableDefinitionCellView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-20.
//

import SwiftUI
import ComposableArchitecture

struct EditableDefinitionCellView: View {
    let store: Store<EditableDefinition, EditableDefinitionAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                TextField(
                    "Enter your definition",
                    text: viewStore.binding(get: { $0.title },
                                            send: EditableDefinitionAction.textFieldChanged)
                )
            }
        }
    }
}

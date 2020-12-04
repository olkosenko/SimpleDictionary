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
                TextArea("Enter your definition", text:
                            viewStore.binding(get: { $0.title },
                                              send: EditableDefinitionAction.textFieldChanged)
                )
                
                Spacer()
                
                Text(viewStore.partOfSpeech.rawValue)
                    .contextMenu {
                        ForEach(PartOfSpeech.allCases) { partOfSpeech in
                            Button(partOfSpeech.rawValue) { viewStore.send(.pickerValueChanged(partOfSpeech)) }
                        }
                    }
                    .foregroundColor(.blue)
            }
        }
    }
}

/// https://stackoverflow.com/a/63680898
fileprivate struct TextArea: View {
    private let placeholder: String
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        TextEditor(text: $text)
            .allowsTightening(true)
            .background(
                HStack(alignment: .center) {
                    text.isBlank ? Text(placeholder) : Text("")
                    Spacer()
                }
                .foregroundColor(Color.primary.opacity(0.25))
                .padding(EdgeInsets(top: 7, leading: 4, bottom: 7, trailing: 0))
            )
    }
}

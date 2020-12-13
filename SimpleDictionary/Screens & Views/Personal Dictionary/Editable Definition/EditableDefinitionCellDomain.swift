//
//  DefinitionCellDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-20.
//

import Foundation
import ComposableArchitecture

struct EditableDefinition: Equatable, Identifiable {
    let id: UUID
    var title: String
    var partOfSpeech: PartOfSpeech
    
    init(id: UUID, title: String = "", partOfSpeech: PartOfSpeech = .noun) {
        self.id = id
        self.title = title
        self.partOfSpeech = partOfSpeech
    }
    
    var isTitleEmpty: Bool { title.isEmpty }
}

enum EditableDefinitionAction: Equatable {
    case textFieldChanged(String)
    case pickerValueChanged(PartOfSpeech)
}

struct EditableDefinitionEnviroment {}

let editableDefinitionReducer = Reducer<EditableDefinition, EditableDefinitionAction, EditableDefinitionEnviroment> {
    state, action, _ in
    
    switch action {
    
    case .textFieldChanged(let newTitle):
        state.title = newTitle
        return .none
        
    case .pickerValueChanged(let newPartOfSpeech):
        state.partOfSpeech = newPartOfSpeech
        return.none
    }
}


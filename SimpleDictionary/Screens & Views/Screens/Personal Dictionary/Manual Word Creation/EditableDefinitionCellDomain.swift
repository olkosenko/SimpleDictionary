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
    var title = ""
    var partOfSpeech: PartOfSpeech = .noun
}

enum EditableDefinitionAction: Equatable {
    case textFieldChanged(String)
    case pickerValueChanged(PartOfSpeech)
}

struct EditableDefinitionEnviroment {}

let editableDefinitionReducer = Reducer<EditableDefinition, EditableDefinitionAction, EditableDefinitionEnviroment> {
    definition, action, _ in
    
    switch action {
    
    case .textFieldChanged(let newTitle):
        definition.title = newTitle
        return .none
        
    case .pickerValueChanged(let newPartOfSpeech):
        definition.partOfSpeech = newPartOfSpeech
        return.none
    }
}


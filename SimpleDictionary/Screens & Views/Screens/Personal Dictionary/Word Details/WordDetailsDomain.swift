//
//  WordDetailsDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-22.
//

import Foundation
import ComposableArchitecture


struct WordDetailsState: Equatable {
    let title: String
    var definitions: IdentifiedArrayOf<EditableDefinition>
    
    var isAddButtonDisabled: Bool {
        definitions.first?.isTitleEmpty ?? false
    }
}

enum WordDetailsAction: Equatable {
    case addDefinitionButtonTapped
    case removeDefinition(IndexSet)
    
    case definition(id: UUID, action: EditableDefinitionAction)
}

struct WordDetailsEnvironment {
    let dataProvider: PersonalDictionaryDataProvider
    let uuid: () -> UUID
}

let wordDetailsReducer = Reducer<
    WordDetailsState, WordDetailsAction, WordDetailsEnvironment
>.combine(
    editableDefinitionReducer.forEach(
        state: \.definitions,
        action: /WordDetailsAction.definition(id:action:),
        environment: { _ in EditableDefinitionEnviroment() }
    ),
    Reducer { state, action, environment in
        
        switch action {
        
        case .addDefinitionButtonTapped:
            state.definitions.insert(.init(id: environment.uuid()), at: 0)
            return .none
            
        case .removeDefinition(let indexSet):
            state.definitions.remove(atOffsets: indexSet)
            return .none
            
        case .definition:
            return .none
                
        }
    }
)

//
//  ManualWordCreationDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-20.
//

import Foundation
import ComposableArchitecture


struct ManualWordCreationState: Equatable {
    var title = ""
    var isSheetPresented = true
    var definitions = IdentifiedArrayOf<EditableDefinition>()
    var isAddButtonDisabled: Bool {
        definitions.first?.title.isEmpty ?? false
    }
    
    var alert: AlertState<ManualWordCreationAction>?
    
    static func == (lhs: ManualWordCreationState, rhs: ManualWordCreationState) -> Bool {
        lhs.title == rhs.title &&
            lhs.definitions == rhs.definitions &&
            lhs.isSheetPresented == rhs.isSheetPresented
    }
}

enum ManualWordCreationAction {
    case onAppear
    
    case wordChanged(String)
    
    case definition(id: UUID, action: EditableDefinitionAction)
    case addDefinitionButtonTapped
    case removeDefinition(IndexSet)
    
    case saveData
    case saveDataResponse(Result<Word, Error>)
    
    case cancelButtonTapped
    case alertDismissed
}

struct ManualWordCreationEnvironment {
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let dataProvider: PersonalDictionaryDataProvider
    let uuid: () -> UUID
}

let manualWordAddingReducer = Reducer<
    ManualWordCreationState, ManualWordCreationAction, ManualWordCreationEnvironment
>.combine(
    editableDefinitionReducer.forEach(
        state: \.definitions,
        action: /ManualWordCreationAction.definition(id:action:),
        environment: { _ in EditableDefinitionEnviroment() }
    ),
    Reducer { state, action, environment in
        
        switch action {
        
        case .onAppear:
            state.definitions.append(.init(id: environment.uuid(), title: "", partOfSpeech: .noun))
            return .none
        
        case .wordChanged(let newWord):
            state.title = newWord
            return .none
            
        case .definition:
            return .none
            
        case .addDefinitionButtonTapped:
            state.definitions.insert(.init(id: environment.uuid()), at: 0)
            return .none
            
        case .removeDefinition(let indexSet):
            state.definitions.remove(atOffsets: indexSet)
            return .none
            
        case .saveData:
            if state.title.isNotEmpty {
                
                var definitions = [PartOfSpeech : [String]]()
                state.definitions.forEach { definition in
                    guard definition.title.isNotEmpty else { return }
                    
                    if definitions[definition.partOfSpeech] != nil {
                        definitions[definition.partOfSpeech]!.append(definition.title)
                    } else {
                        definitions[definition.partOfSpeech] = [definition.title]
                    }
                }
                
                return environment.dataProvider.saveWord(title: state.title, definitions: definitions)
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(ManualWordCreationAction.saveDataResponse)
                
            } else {
                state.alert = .init(
                    title: "Alert",
                    message: "We cannot save your word cause title is empty",
                    dismissButton: .cancel())
                return .none
                
            }
            
        case .saveDataResponse(.success(let word)):
            state.isSheetPresented = false
            return .none
            
        case .saveDataResponse(.failure):
            state.alert = .init(
                title: "Alert",
                message: "Something bad happend and we were not able to save your word :(",
                dismissButton: .cancel())
            return .none
            
        case .cancelButtonTapped:
            state.isSheetPresented = false
            return .none
            
        case .alertDismissed:
            state.alert = nil
            return .none
            
        }
    }
)


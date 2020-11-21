//
//  ManualWordCreationView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-19.
//

import SwiftUI
import ComposableArchitecture

struct ManualWordCreationView: View {
    typealias ViewStoreType = ViewStore<ManualWordCreationState, ManualWordCreationAction>
    let store: Store<ManualWordCreationState, ManualWordCreationAction>
    
    @Environment(\.presentationMode) var presentationMode
    
    enum Const {
        static let buttonWidth: CGFloat = 120
        static let buttonHeight: CGFloat = 40
        static var buttonCornerRadius: CGFloat {
            let smallestValue = min(buttonWidth, buttonHeight)
            return CGFloat(smallestValue / 2)
        }
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                GeometryReader { proxy in
                    ZStack {
                        form(viewStore)
                        saveButton(in: proxy.size, viewStore)
                            .ignoresSafeArea(.keyboard, edges: .bottom)
                            .alert(
                              store.scope(state: { $0.alert }),
                              dismiss: .alertDismissed
                            )
                    }
                }
                .navigationBarItems(leading:  cancelNavigationButton(viewStore),
                                    trailing: saveNavigationButton(viewStore))
                .navigationBarTitle("New Word",
                                    displayMode: .inline)
            }
            .onAppear { viewStore.send(.onAppear) }
            .onChange(of: viewStore.isSheetPresented) { isPresented in
                if !isPresented { presentationMode.wrappedValue.dismiss() }
            }
        }
    }
    
    
    func form(_ viewStore: ViewStoreType) -> some View {
        Form {
            
            Section(header: Text("Word")) {
                TextField(
                    "Enter your word",
                    text: viewStore.binding(get: { $0.title },
                                            send: ManualWordCreationAction.wordChanged))
            }
            
            Section(header: formAddButton(viewStore)) {
                ForEachStore(
                    store.scope(state: { $0.definitions },
                                action: ManualWordCreationAction.definition),
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
                    .font(Font.headline.weight(.medium))
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(viewStore.isAddButtonDisabled)
        }
    }
    
    func saveButton(in size: CGSize, _ viewStore: ViewStoreType) -> some View {
        DictionaryButton(action: { viewStore.send(.saveData) }) {
            Text("Save")
        }
        .cornerRadius(Const.buttonCornerRadius)
        .frame(width: Const.buttonWidth, height: Const.buttonHeight)
        .offset(buttonOffset(in: size))
    }
    
    func cancelNavigationButton(_ viewStore: ViewStoreType) -> some View {
        Button(action: { viewStore.send(.cancelButtonTapped) }) {
            Image(systemName: "chevron.down")
        }
    }
    
    func saveNavigationButton(_ viewStore: ViewStoreType) -> some View {
        Button(action: { viewStore.send(.saveData) }) {
            Text("Save")
        }
    }
    
    func buttonOffset(in size: CGSize) -> CGSize {
        let bottomPadding: CGFloat = 20
        let heightOffset = size.height / 2 - Const.buttonHeight / 2 - bottomPadding

        return CGSize(width: 0, height: heightOffset)
    }
}

//struct ManualWordCreationViewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ManualWordCreationView(
//        store: Store(
//            initialState: ManualWordCreationState(),
//            reducer: manualWordAddingReducer,
//            environment: ManualWordCreationEnvironment(
//                mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
//                uuid: UUID.init,
//                dataProvider: PersonalDictionaryDataProvider(apiService: APIService(),
//                                                             coreDataService: CoreDataService())))
//        )
//    }
//}

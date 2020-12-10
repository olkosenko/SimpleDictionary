//
//  SearchSettingsView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-01.
//

import SwiftUI
import ComposableArchitecture

struct SearchSettingsView: View {
    typealias ViewStoreType = ViewStore<SearchSettingsState, SearchSettingsAction>
    let store: Store<SearchSettingsState, SearchSettingsAction>
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack {
                    Form {
                        dashboardSettings(viewStore)
                    }
                }
                .navigationBarItems(trailing: Button("Done", action: { presentationMode.wrappedValue.dismiss() }))
                .navigationBarTitle("Settings", displayMode: .inline)
            }
            .onAppear { viewStore.send(.onAppear) }
        }
    }
    
    func dashboardSettings(_ viewStore: ViewStoreType) -> some View {
        Section(header: Text("Dashboard")) {
            
            Toggle(
                isOn: viewStore.binding(get: { $0.settings.isSearchGoalActive },
                                        send: SearchSettingsAction.searchToggleChange)) {
                Text("Search Goal")
                    .fontWeight(.regular)
            }
            HStack {
                Text("Count: \(viewStore.settings.searchGoalCount)")
                    .font(Font.body.monospacedDigit())
                Slider(
                    value: viewStore.binding(
                        get: { Double($0.settings.searchGoalCount) },
                        send: SearchSettingsAction.searchSliderChange
                    ),
                    in: viewStore.sliderRange,
                    step: viewStore.sliderStep)
            }
            .disabled(!viewStore.settings.isSearchGoalActive)
            
            Toggle(
                isOn: viewStore.binding(get: { $0.settings.isLearnGoalActive },
                                        send: SearchSettingsAction.learnToggleChange)) {
                Text("Learn Goal")
                    .fontWeight(.regular)
            }

            HStack {
                Text("Count: \(viewStore.settings.learnGoalCount)")
                    .font(Font.body.monospacedDigit())
                Slider(
                    value: viewStore.binding(
                        get: { Double($0.settings.learnGoalCount) },
                        send: SearchSettingsAction.learnSliderChange
                    ),
                    in: viewStore.sliderRange,
                    step: viewStore.sliderStep)
            }
            .disabled(!viewStore.settings.isLearnGoalActive)
            
        }
    }
}

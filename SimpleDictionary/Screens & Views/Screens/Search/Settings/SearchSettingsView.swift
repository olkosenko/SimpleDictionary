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
        NavigationView {
            WithViewStore(store) { viewStore in
                VStack {
                    Form {
                        dashboardSettings(viewStore)
                    }
                }
                .navigationBarItems(trailing: Button("Done",
                                                     action: { presentationMode.wrappedValue.dismiss() }))
                .navigationBarTitle("Settings",
                                    displayMode: .inline)
            }
        }
    }
    
    func dashboardSettings(_ viewStore: ViewStoreType) -> some View {
        Section(header: Text("Dashboard")) {
            
            Toggle(
                isOn: viewStore.binding(get: { $0.isSearchGoalActive },
                                        send: SearchSettingsAction.searchToggleChange)) {
                Text("Search Goal")
                    .fontWeight(.regular)
            }
            HStack {
                Text("Count: \(Int(viewStore.searchGoal))")
                    .font(Font.body.monospacedDigit())
                Slider(
                    value: viewStore.binding(
                        get: { $0.searchGoal },
                        send: SearchSettingsAction.searchSliderChange
                    ),
                    in: viewStore.sliderRange,
                    step: viewStore.sliderStep)
            }
            .disabled(!viewStore.isSearchGoalActive)
            
            Toggle(
                isOn: viewStore.binding(get: { $0.isLearnGoalActive },
                                        send: SearchSettingsAction.learnToggleChange)) {
                Text("Learn Goal")
                    .fontWeight(.regular)
            }

            HStack {
                Text("Count: \(Int(viewStore.learnGoal))")
                    .font(Font.body.monospacedDigit())
                Slider(
                    value: viewStore.binding(
                        get: { $0.learnGoal },
                        send: SearchSettingsAction.learnSliderChange
                    ),
                    in: viewStore.sliderRange,
                    step: viewStore.sliderStep)
            }
            .disabled(!viewStore.isLearnGoalActive)
            
        }
    }
}

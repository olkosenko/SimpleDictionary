//
//  DashboardView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-03.
//

import SwiftUI
import ComposableArchitecture

struct DashboardView: View {
    let store: Store<DashboardState, DashboardAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                
                VStack(alignment: .leading, spacing: 12) {
                    if viewStore.settings.isSearchGoalActive {
                        makeLabel(title: "Search",
                                  result: viewStore.settings.currentSearchCount,
                                  goal: viewStore.settings.searchGoalCount,
                                  metric: "word",
                                  color: .green)
                    }
                    
                    if viewStore.settings.isLearnGoalActive {
                        makeLabel(title: "Learn",
                                  result: viewStore.settings.currentLearnCount,
                                  goal: viewStore.settings.learnGoalCount,
                                  metric: "word",
                                  color: Color.orange.opacity(0.8))
                    }
                }
                .padding(.leading)
                
                Spacer()
                
                GeometryReader { proxy in
                    VStack {
                        Spacer(minLength: 0)
                        ZStack {
                            if viewStore.settings.isSearchGoalActive {
                                CirclesView(progress: viewStore.searchProgress, thickness: 20, color: .green)
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                            }
                            
                            if viewStore.settings.isLearnGoalActive {
                                CirclesView(progress: viewStore.learnProgress, thickness: 20, color: .orange)
                                    .frame(
                                        width: abs(viewStore.settings.isSearchGoalActive ? proxy.size.width-42 : proxy.size.width),
                                        height: abs(viewStore.settings.isSearchGoalActive ? proxy.size.height-42 : proxy.size.height)
                                    )
                            }
                        }
                        Spacer(minLength: 0)
                    }
                }
                
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10)
                            .shadow(color: .black, radius: 4, x: 1.0, y: 1.0)
                            .foregroundColor(.progressViewBackground))
            .onAppear { viewStore.send(.onAppear) }
        }
    }
    
    func makeLabel(title: String, result: Int, goal: Int, metric: String, color: Color) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(.callout, design: .rounded))
                .foregroundColor(.black)
            Text("\(result)/\(goal) \(metric)")
                .font(.system(.body, design: .rounded))
                .bold()
                .foregroundColor(color)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(store: Store(initialState: DashboardState(),
                                   reducer: dashboardReducer,
                                   environment: DashboardEnvironment(userDefaultsDataProvider: AppEnvironment.debug.userDefaultsDataProvider))
        )
        .frame(height: 200)
        .frame(maxWidth: 400)
        .padding()
    }
}

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
                    makeLabel(title: "Search",
                              result: "23",
                              goal: "30",
                              metric: "word",
                              color: .green)
                    
                    makeLabel(title: "Learn",
                              result: "3",
                              goal: "10",
                              metric: "word",
                              color: Color.orange.opacity(0.8))
                }
                .padding(.leading)
                
                Spacer()
                
                GeometryReader { proxy in
                    ZStack {
                        CirclesView(progress: 23/30, thickness: 20, color: .green)
                            .frame(width: proxy.size.width, height: proxy.size.height)
                        
                        CirclesView(progress: 3/10, thickness: 20, color: .orange)
                            .frame(width: abs(proxy.size.width-42), height: abs(proxy.size.height-42))
                    }
                }
                
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10)
                            .shadow(color: .black, radius: 4, x: 1.0, y: 1.0)
                            .foregroundColor(.progressViewBackground))
        }
    }
    
    func makeLabel(title: String, result: String, goal: String, metric: String, color: Color) -> some View {
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

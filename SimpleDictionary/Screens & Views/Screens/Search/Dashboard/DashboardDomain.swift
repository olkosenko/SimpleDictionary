//
//  DashboardDomain.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-01.
//

import Foundation
import ComposableArchitecture

struct DashboardState: Equatable {
    static func == (lhs: DashboardState, rhs: DashboardState) -> Bool {
        return true
    }
    
    var metrics: [Metrics]
    
    enum Metrics {
        case search(MetricData)
        case learn(MetricData)
        
        var name: String {
            switch self {
            case .learn:
                return "Learn"
            case .search:
                return "Search"
            }
        }
    }
    
    struct MetricData {
        var isVisible: Bool
        var currentValue: Int
        var goalValue: Int
    }
}

enum DashboardAction {}
struct DashboardEnvironment {}

let dashboardReducer = Reducer<DashboardState, DashboardAction, DashboardEnvironment> { _, _, _ in .none }

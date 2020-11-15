//
//  Date.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-02.
//

import Foundation

extension Date {
    
    static let yearMonthDayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    var yearMonthDay: String {
        return Date.yearMonthDayDateFormatter.string(from: self)
    }
    
    func changed(with components: DateComponents) -> Date {
        return Calendar.current.date(byAdding: components, to: self) ?? self
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

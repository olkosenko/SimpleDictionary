//
//  Date.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-02.
//

import Foundation

extension Date {
    var yearMonthDayLocal: String {
        DateFormatter.yearMonthDayLocalDateFormatter.string(from: self)
    }
    
    var yearMonthDayUTC0: String {
        DateFormatter.yearMonthDayUTC0DateFormatter.string(from: self)
    }
    
    var wod: String {
        let components = Calendar.utcCalendar.dateComponents([.day, .month, .year], from: self)
        if let day = components.day, let month = components.month, let year = components.year {
            let formattedMonth = DateFormatter.yearMonthDayUTC0DateFormatter.monthSymbols[month-1].capitalizeFirst()
            return "\(formattedMonth) \(day), \(year)"
        }
        return yearMonthDayLocal
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

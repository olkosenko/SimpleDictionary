//
//  CalendarExtension.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-29.
//

import Foundation

extension Calendar {
    static let utcCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar
    }()
}

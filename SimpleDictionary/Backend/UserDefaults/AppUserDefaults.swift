//
//  AppUserDefaults.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-14.
//

import Foundation

struct AppUserDefaults {
    @UserDefault("count_WODs", defaultValue: 7)
    static var countWODs: Int
    
    
}

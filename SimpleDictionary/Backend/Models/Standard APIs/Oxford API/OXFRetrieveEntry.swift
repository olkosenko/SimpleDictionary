//
//  RetrieveEntry.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import Foundation

struct OXFRetrieveEntry: Decodable {
    /// A list of entries and all the data related to them.
    let results: [OXFHeadwordEntry]?
}

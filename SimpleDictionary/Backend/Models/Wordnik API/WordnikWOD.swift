//
//  WordnikWOD.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-02.
//

import Foundation

struct WordnikWOD: Decodable {
    let word: String?
    let publishDate: String?
    let definitions: [Definitions]?
    
    struct Definitions: Decodable {
        let text: String?
        let partOfSpeech: String?
    }
}

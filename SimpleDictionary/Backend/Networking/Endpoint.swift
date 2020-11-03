//
//  Endpoint.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-01.
//

import Foundation

enum Endpoint {
    case oxford(OxfordEndpoint)
    case merriamWebster(MerriamWebsterEndpoint)
    case urban(UrbanEndpoint)
    case wordnik(WordnikEndpoint)
    
    var path: String {
        switch self {
        case .oxford(let oxford):
            return oxford.path
        case .merriamWebster(let merriamWebster):
            return merriamWebster.path
        case .urban(let urban):
            return urban.path
        case .wordnik(let wordnik):
            return wordnik.path
        }
    }
}
    
enum OxfordEndpoint {
    case definitions(word: String)
    case thesaurus(word: String)
    
    var path: String {
        switch self {
        case .definitions:
            return "entries"
        case .thesaurus:
            return "thesaurus"
        }
    }
    
    var word: String {
        switch self {
        case .definitions(let word):
            return word
        case .thesaurus(let word):
            return word
        }
    }
}

enum MerriamWebsterEndpoint {
    case definitions(word: String)
    case thesaurus(word: String)
    
    var path: String {
        switch self {
        case .definitions:
            return "collegiate"
        case .thesaurus:
            return "thesaurus"
        }
    }
    
    var word: String {
        switch self {
        case .definitions(let word):
            return word
        case .thesaurus(let word):
            return word
        }
    }
}

enum UrbanEndpoint {
    case definitions(word: String)
    
    var path: String {
        switch self {
        case .definitions:
            return "define"
        }
    }
    
    var word: String {
        switch self {
        case .definitions(let word):
            return word
        }
    }
}

enum WordnikEndpoint {
    case wod(date: Date)
    case randomWord
    
    var path: String {
        switch self {
        case .wod:
            return "words.json/wordOfTheDay"
        case .randomWord:
            return "words.json/randomWord"
        
        }
    }
}

//
//  MerriamWebsterEntry.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-05.
//

import Foundation

/// This is the worst API I have ever worked with (docs suck as well) :(
struct MerriamWebsterEntry: Decodable {
    let entries: MWEntry
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        entries = try container.decode(MWEntry.self)
    }
}

struct MWEntry: Decodable {
    let headwordInfo: MWHeadwordInfo
    let partOfSpeech: PartOfSpeech
    let definitions: [MWDefinition]
    
    enum CodingKeys: String, CodingKey {
        case headwordInfo = "hwi"
        case partOfSpeech = "fl"
        case definitions = "def"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        headwordInfo = try values.decode(MWHeadwordInfo.self, forKey: .headwordInfo)
        definitions = try values.decode([MWDefinition].self, forKey: .definitions)

        let partOfSpeechRawValue = try values.decode(String.self, forKey: .partOfSpeech)
        partOfSpeech = PartOfSpeech(rawValue: partOfSpeechRawValue) ?? .noun
    }
}

struct MWHeadwordInfo: Decodable {
    let pronunciations: [Pronunciation]
    
    enum CodingKeys: String, CodingKey {
        case pronunciations = "prs"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pronunciations = try values.decode([Pronunciation].self, forKey: .pronunciations)
    }
    
    struct Pronunciation: Decodable {
        let phoneticSpelling: String?
        let soundURL: URL?
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            if values.contains(.phoneticSpelling) {
                phoneticSpelling = try values.decode(String.self, forKey: .phoneticSpelling)
            } else {
                phoneticSpelling = nil
            }
            
            if values.contains(.sound) {
                let filename = try values.decode(Sound.self, forKey: .sound)
                let subdirectory = Pronunciation.extractSubdirectory(from: filename.audio)
                soundURL = URL(string: "https://media.merriam-webster.com/audio/prons/en/us/mp3/\(subdirectory)/\(filename.audio).mp3")
            } else {
                soundURL = nil
            }
        }
        
        struct Sound: Decodable {
            let audio: String
        }
        
        enum CodingKeys: String, CodingKey {
            case phoneticSpelling = "mw"
            case sound
        }
        
        private static let audioNumberAndPunctuation: [String] = {
            var punctuationAndNumbers = ["_", "/", "\\", "-", "!", ",", "."]
            punctuationAndNumbers.append(contentsOf: (0..<10).map { String($0) })
            return punctuationAndNumbers
        }()
        
        private static func extractSubdirectory(from filename: String) -> String {
            if filename.starts(with: "bix") { return "bix" }
            if filename.starts(with: "gg") { return "gg" }
            
            guard let firstLetter = filename.first else { return "" }
            if Pronunciation.audioNumberAndPunctuation.contains(String(firstLetter)) { return String(firstLetter) }
            return String(firstLetter)
        }
    }
}

struct MWDefinition: Decodable {
    let senseSequences: [SenseSequence]
    
    enum CodingKeys: String, CodingKey {
        case senseSequences = "sseq"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        senseSequences = try container.decode([SenseSequence].self, forKey: .senseSequences)
    }
    
    struct SenseSequence: Decodable {
        let senses: [Sense]
        
        init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            senses = try container.decode([Sense].self)
        }
        
        struct Sense: Decodable {
            let definitionsDict: DefinitionsDict?
            
            init(from decoder: Decoder) throws {
                do {
                    let container = try decoder.singleValueContainer()
                    definitionsDict = try container.decode(DefinitionsDict.self)
                }
                catch {
                    definitionsDict = nil
                }
            }
            
            struct DefinitionsDict: Decodable {
                let definitions: [Definition]
                
                enum CodingKeys: String, CodingKey {
                    case definitions = "dt"
                }
                
                struct Definition: Decodable {
                    let text: String
                    
                    init(from decoder: Decoder) throws {
                        do {
                            let container = try decoder.singleValueContainer()
                            text = try container.decode([String].self).last ?? ""
                        }
                        catch {
                            text = ""
                        }
                    }
                    
                    // struct Definition
                }
            }
        }
    }
    
}

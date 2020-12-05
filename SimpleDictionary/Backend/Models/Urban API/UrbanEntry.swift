//
//  UrbanEntry.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-02.
//

import Foundation

struct UrbanEntry: Decodable, Equatable {
    let list: [Definition]
    
    struct Definition: Decodable, Equatable, Hashable {
        let definition: String
        let permalink: URL?
        let author: String
        let example: String
        
        let thumbsUp: Int
        let thumbsDown: Int
        let writtenOn: Date?
        let soundURLs: [String]
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            definition = try values.decode(String.self, forKey: .definition)
                .withRemovedFormatting
                .capitalizeFirst()
            
            example = try values.decode(String.self, forKey: .example)
                .withRemovedFormatting
                .capitalizeFirst()
            
            let permalinkString = try values.decode(String.self, forKey: .permalink)
            permalink = URL(string: permalinkString)
            
            let writtenOnString = try values.decode(String.self, forKey: .writtenOn)
            writtenOn = DateFormatter.isoDateFormatter.date(from: writtenOnString)
            
            author = try values.decode(String.self, forKey: .author)
            thumbsUp = try values.decode(Int.self, forKey: .thumbsUp)
            thumbsDown = try values.decode(Int.self, forKey: .thumbsDown)
            soundURLs = try values.decode([String].self, forKey: .soundURLs)
        }
        
        enum CodingKeys: String, CodingKey {
            case definition
            case permalink
            case author
            case example
            
            case thumbsUp = "thumbs_up"
            case thumbsDown = "thumbs_down"
            case writtenOn = "written_on"
            case soundURLs = "sound_urls"
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(permalink)
        }
    }
}

fileprivate extension String {
    var withRemovedFormatting: String {
        self.replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
    }
}

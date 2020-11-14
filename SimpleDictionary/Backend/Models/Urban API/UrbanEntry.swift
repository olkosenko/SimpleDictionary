//
//  UrbanEntry.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-02.
//

import Foundation
import Combine

struct UrbanEntry: Decodable {
    let list: [Definition]?
    
    struct Definition: Decodable {
        let definition: String
        let permalink: URL
        let author: String
        let example: String
        
        let thumbsUp: Int
        let thumbsDown: String
        let writtenOn: Date
        let soundURLs: [URL]
        
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
    }
}

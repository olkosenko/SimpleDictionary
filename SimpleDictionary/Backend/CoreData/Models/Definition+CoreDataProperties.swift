//
//  Definition+CoreDataProperties.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-14.
//
//

import Foundation
import CoreData


extension Definition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Definition> {
        return NSFetchRequest<Definition>(entityName: "Definition")
    }
    
    var normalizedPartOfSpeech: PartOfSpeech {
        get {
            partOfSpeech == nil ? .noun : PartOfSpeech(rawValue: partOfSpeech!) ?? .noun
        }
        set {
            partOfSpeech = newValue.rawValue
        }
    }
    var normalizedTitle: String { title ?? "" }
    var normalizedId: UUID { id ?? UUID() }
    
    @NSManaged public var title: String?
    @NSManaged public var id: UUID?
    @NSManaged public var partOfSpeech: String?
    @NSManaged public var word: Word?
}

extension Definition {
    static let mockDefinitions: Set<Definition> = {
        let definition1 = Definition()
        let definition2 = Definition()
        let definition3 = Definition()
        
        definition1.title = "Some text"
        definition2.title = "Some more text"
        definition3.title = "And finally something else"
        
        return Set([definition1, definition2, definition3])
    }()
}

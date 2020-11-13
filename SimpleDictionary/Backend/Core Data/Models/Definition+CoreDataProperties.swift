//
//  Definition+CoreDataProperties.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-13.
//
//

import Foundation
import CoreData


extension Definition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Definition> {
        return NSFetchRequest<Definition>(entityName: "Definition")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var definition: String?
    @NSManaged public var partOfSpeech: String?
    @NSManaged public var word: Word?

}

extension Definition : Identifiable {

}

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

    @NSManaged public var title: String?
    @NSManaged public var id: UUID?
    @NSManaged public var partOfSpeech: String?
    @NSManaged public var word: Word?

}

extension Definition : Identifiable {

}

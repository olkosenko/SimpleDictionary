//
//  Word+CoreDataProperties.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-14.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    var unwrappedDate: Date {
        date ?? Date()
    }
    
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isWOD: NSNumber?
    @NSManaged public var phoneticSpelling: String?
    @NSManaged public var soundURL: URL?
    @NSManaged public var title: String?
    @NSManaged public var definitions: NSSet?

}

// MARK: Generated accessors for definitions
extension Word {

    @objc(addDefinitionsObject:)
    @NSManaged public func addToDefinitions(_ value: Definition)

    @objc(removeDefinitionsObject:)
    @NSManaged public func removeFromDefinitions(_ value: Definition)

    @objc(addDefinitions:)
    @NSManaged public func addToDefinitions(_ values: NSSet)

    @objc(removeDefinitions:)
    @NSManaged public func removeFromDefinitions(_ values: NSSet)

}

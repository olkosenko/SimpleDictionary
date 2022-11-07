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
    
    var normalizedId: UUID { id ?? UUID() }
    var normalizedDate: Date { date ?? Date() }
    var normalizedTitle: String { title ?? "" }
    var normalizedDefinitions: Set<Definition> {
        guard let def = definitions, let set = def as? Set<Definition> else { return .init() }
        return set
    }
    var isWODNormalized: Bool {
        Bool(truncating: isWOD ?? false)
    }
    
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isWOD: NSNumber?
    @NSManaged public var phoneticSpelling: String?
    @NSManaged public var soundURL: URL?
    @NSManaged public var title: String?
    @NSManaged public var isLearned: Bool
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

extension Word {
    static let wordMock: Word = {
        let word = Word()
        word.title = "Milk"
        Definition.mockDefinitions.forEach { word.addToDefinitions($0) }
        return word
    }()
}

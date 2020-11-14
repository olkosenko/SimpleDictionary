//
//  ManagedObjectContext.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-13.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func fetchEntities<Entity: NSManagedObject>(ofType type: Entity.Type,
                                                with predicate: NSPredicate? = nil,
                                                sortDescriptors: [NSSortDescriptor]? = nil,
                                                returnsObjectsAsFaults: Bool = true,
                                                fetchLimit: Int? = nil) throws -> [Entity] {
        
        let fetchRequest = type.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = returnsObjectsAsFaults
        fetchRequest.sortDescriptors = sortDescriptors
        if let fetchLimit = fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }

        let fetchedObjects = try self.fetch(fetchRequest) as? [Entity]
        return fetchedObjects ?? []
    }
    
    @discardableResult
    func saveIfNeeded() -> Bool {
        guard hasChanges else {
            return true
        }

        do {
            try self.save()
            return true
        } catch {
            let nserror = error as NSError
            print("Saving of context failed. Error \(error.localizedDescription) info: \(nserror.userInfo)")
            return false
        }
    }
    
    @discardableResult
    func writeSync(_ block: @escaping (NSManagedObjectContext) -> Void) -> Bool {
        var saved = false
        performAndWait {
            block(self)
            saved = self.saveIfNeeded()
        }

        return saved
    }
    
    func writeAsync(_ block: @escaping (NSManagedObjectContext) -> Void) {
        perform {
            block(self)
            self.saveIfNeeded()
        }
    }
    
    func sync(_ block: @escaping (NSManagedObjectContext) -> Void) {
        performAndWait {
            block(self)
        }
    }

    func async(_ block: @escaping (NSManagedObjectContext) -> Void) {
        perform {
            block(self)
        }
    }
}

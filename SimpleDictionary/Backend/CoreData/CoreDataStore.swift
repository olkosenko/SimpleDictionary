//
//  CoreDataStore.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-12.
//

import Foundation
import CoreData

final class CoreDataStore {
    
    private enum Const {
        static let containerName = "dictionary"
    }
    
    let mainContext: NSManagedObjectContext
    private let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: Const.containerName)
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        mainContext = persistentContainer.viewContext
    }
}

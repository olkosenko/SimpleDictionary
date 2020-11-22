//
//  CoreDataPublisher.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-21.
//

import Foundation
import Combine
import CoreData

class CoreDataPublisher<Entity: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    let publisher = CurrentValueSubject<[Entity], Error>([])
    
    private let context: NSManagedObjectContext
    private let fetchRequest: NSFetchRequest<Entity>
    private lazy var frc: NSFetchedResultsController<Entity> = {
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        
        return frc
    }()
    
    init(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Entity>) {
        self.context = context
        self.fetchRequest = fetchRequest
        super.init()

        initialFetch()
    }
    
    private func initialFetch() {
        do {
            try frc.performFetch()
            let result = frc.fetchedObjects ?? []
            publisher.value = result
        }
        catch {
            publisher.send(completion: .failure(error))
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("Hello")
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let result = controller.fetchedObjects as? [Entity] ?? []
        publisher.value = result
    }
}

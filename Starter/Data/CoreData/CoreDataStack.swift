//
//  CoreDataStack.swift
//  Spendometer
//
//  Created by Thet Htun on 7/20/21.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    let persistentContainer : NSPersistentContainer
    
    var context : NSManagedObjectContext {
        get {
            persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            return persistentContainer.viewContext
        }
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MovieDB")

        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data store failed to load with error: \(error)")
            }
        }
    }
    
    func saveContext() {
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

}

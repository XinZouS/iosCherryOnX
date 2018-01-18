//
//  CoreDataManager.swift
//  carryonex
//
//  Created by Chen, Zian on 1/16/18.
//  Copyright © 2018 CarryonEx. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    public func managedContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CarryonEx")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

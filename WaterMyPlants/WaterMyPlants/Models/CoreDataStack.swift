//
//  CoreDataStack.swift
//  WaterMyPlants
//
//  Created by John McCants on 2/25/21.
//

import Foundation
import CoreData

class CoreDataStack {
   
    let modelName = "WaterMyPlants"
    static let shared = CoreDataStack()
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Plant")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error with container: \(error)")
            }
        }
        return container
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        print("This is the ManagedObjectModel: \(managedObjectModel)")
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"

        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

        do {
            let options = [ NSInferMappingModelAutomaticallyOption : true,
                            NSMigratePersistentStoresAutomaticallyOption : true]

            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator

        return managedObjectContext
    }()
    
//    var mainContext: NSManagedObjectContext {
//        let context = container.viewContext
//        context.automaticallyMergesChangesFromParent = true
//        return context
//    }
    func save(context: NSManagedObjectContext = CoreDataStack.shared.managedObjectContext) throws {
        context.performAndWait {
            do {
                try context.save()
            } catch let error {
                print("Save Error: \(error)")
            }
        }
    }
    
    func delete(object: NSManagedObject) {
            let context = CoreDataStack.shared.managedObjectContext
            context.delete(object)
    }
    
    func updatePlant(id: Int16, frequency: String, image: Data?, nickname: String, species: String, timestamp: Date, plant: Plant) {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        let context = CoreDataStack.shared.managedObjectContext
        fetchRequest.predicate = NSPredicate(format:"timestamp = %@", plant.timestamp! as CVarArg)
        
        
        
        let result = try? context.fetch(fetchRequest)
        print(result?.count)
        if result?.count == 1 {

            let dict = result![0]
            dict.setValue(id, forKey: "id")
            dict.setValue(nickname, forKey: "nickname")
            dict.setValue(frequency, forKey: "frequency")
            dict.setValue(timestamp, forKey: "timestamp")
            dict.setValue(species, forKey: "species")
            guard let newPlantImage = image else {
                do {
                try context.save()
            } catch let error {
                print("Save Error: \(error)")
            }
               return
            }
            dict.setValue(newPlantImage, forKey: "image")
            do {
                try context.save()
            } catch let error {
                print("Save Error: \(error)")
            }
        }
    }
}



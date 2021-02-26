//
//  Plant+CoreDataProperties.swift
//  WaterMyPlants
//
//  Created by John McCants on 2/24/21.
//
//

import Foundation
import CoreData

extension Plant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var frequency: String?
    @NSManaged public var id: Int16
    @NSManaged public var image: Data?
    @NSManaged public var nickname: String?
    @NSManaged public var species: String?
    @NSManaged public var timestamp: Date?
    @discardableResult convenience init(frequency: String?, id: Int, image: Data?, nickname: String?, species: String?, timestamp: Date?, context: NSManagedObjectContext = CoreDataStack.shared.managedObjectContext) {
        self.init(context: context)
        self.id = Int16(id)
        self.image = image
        self.nickname = nickname
        self.species = species
        self.frequency = frequency
        self.timestamp = timestamp
    }
}

extension Plant: Identifiable {

}

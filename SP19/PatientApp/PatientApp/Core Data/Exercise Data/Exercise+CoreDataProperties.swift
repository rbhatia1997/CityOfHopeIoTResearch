//
//  Exercise+CoreDataProperties.swift
//  PatientApp
//
//  Created by Darien Joso on 4/4/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var icon: String
    @NSManaged public var image: String
    @NSManaged public var meta: Set<Meta>
    @NSManaged public var use: Bool
    @NSManaged public var detection: String
}

// MARK: Generated accessors for meta
extension Exercise {

    @objc(addMetaObject:)
    @NSManaged public func addToMeta(_ value: Meta)

    @objc(removeMetaObject:)
    @NSManaged public func removeFromMeta(_ value: Meta)

    @objc(addMeta:)
    @NSManaged public func addToMeta(_ values: NSSet)

    @objc(removeMeta:)
    @NSManaged public func removeFromMeta(_ values: NSSet)

}

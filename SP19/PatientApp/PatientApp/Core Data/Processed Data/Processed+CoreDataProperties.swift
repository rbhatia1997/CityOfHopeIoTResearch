//
//  Processed+CoreDataProperties.swift
//  PatientApp
//
//  Created by Darien Joso on 4/4/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//
//

import Foundation
import CoreData


extension Processed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Processed> {
        return NSFetchRequest<Processed>(entityName: "Processed")
    }

    @NSManaged public var id: String
    @NSManaged public var q_gb: [[Float]]
    @NSManaged public var q_b1: [[Float]]
    @NSManaged public var q_b2: [[Float]]
    @NSManaged public var q_b3: [[Float]]
    @NSManaged public var timestep: [Float]
    @NSManaged public var meta: Meta?

}

//
//  Meta+CoreDataProperties.swift
//  PatientApp
//
//  Created by Darien Joso on 4/4/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//
//

import Foundation
import CoreData


extension Meta {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meta> {
        return NSFetchRequest<Meta>(entityName: "Meta")
    }

    @NSManaged public var id: String
    @NSManaged public var rom: [Float]
    @NSManaged public var reps: Int16
    @NSManaged public var mean: Float
    @NSManaged public var max: Float
    @NSManaged public var min: Float
    @NSManaged public var slouch: Float
    @NSManaged public var comp: Float
    @NSManaged public var exercise: Exercise?
    @NSManaged public var processed: Processed?

}

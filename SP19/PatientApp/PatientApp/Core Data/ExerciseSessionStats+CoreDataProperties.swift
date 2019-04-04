//
//  ExerciseSessionStats+CoreDataProperties.swift
//  PatientApp
//
//  Created by Darien Joso on 3/26/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//
//

import Foundation
import CoreData


extension ExerciseSessionStats {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseSessionStats> {
        return NSFetchRequest<ExerciseSessionStats>(entityName: "ExerciseSessionStats")
    }

    @NSManaged public var date: Date
    @NSManaged public var repCount: Int16
    @NSManaged public var maxROM: Float
    @NSManaged public var exercise: Exercise

}

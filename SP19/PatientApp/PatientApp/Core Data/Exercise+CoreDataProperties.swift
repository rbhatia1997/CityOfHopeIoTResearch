//
//  Exercise+CoreDataProperties.swift
//  PatientApp
//
//  Created by Darien Joso on 3/26/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var exerciseName: String
    @NSManaged public var date: Date
    @NSManaged public var exerciseSessionStats: ExerciseSessionStats?

}

// MARK: Generated accessors for exerciseSessionStats
extension Exercise {

    @objc(addExerciseSessionStatsObject:)
    @NSManaged public func addToExerciseSessionStats(_ value: ExerciseSessionStats)

    @objc(removeExerciseSessionStatsObject:)
    @NSManaged public func removeFromExerciseSessionStats(_ value: ExerciseSessionStats)

    @objc(addExerciseSessionStats:)
    @NSManaged public func addToExerciseSessionStats(_ values: NSSet)

    @objc(removeExerciseSessionStats:)
    @NSManaged public func removeFromExerciseSessionStats(_ values: NSSet)

}

//
//  ExerciseData.swift
//  PatientApp
//
//  Created by Darien Joso on 4/4/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import CoreData

// MARK: Exercise Data Management
var exercises = [Exercise]()

func getExerciseData(_ sort: [NSSortDescriptor]) -> [Exercise] {
    let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    fetchRequest.sortDescriptors = sort
    fetchRequest.predicate = NSPredicate(format: "use == %@", NSNumber(value: true))
    
    do {
        let exerciseArr = try context.fetch(fetchRequest)
        print("Fetched exercise data successfully")
        return exerciseArr
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    return []
}

func getAllExerciseData(_ sort: [NSSortDescriptor]) -> [Exercise] {
    let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    fetchRequest.sortDescriptors = sort
    
    do {
        let exerciseArr = try context.fetch(fetchRequest)
        print("Fetched exercise data successfully")
        return exerciseArr
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    return []
}

func reloadExerciseData() {
    exercises = getExerciseData( [NSSortDescriptor(key: #keyPath(Exercise.id), ascending: true)] )
}

func reloadExerciseData(_ sort: [NSSortDescriptor]) {
    exercises = getExerciseData(sort)
}

func reloadAllExerciseData() {
    exercises = getAllExerciseData( [NSSortDescriptor(key: #keyPath(Exercise.id), ascending: true)] )
}

func reloadAllExerciseData(_ sort: [NSSortDescriptor]) {
    exercises = getAllExerciseData(sort)
}

func addExerciseData(id: String, name: String, image: String, icon: String, use: Bool, detection: String) {
    let exercise = Exercise(context: context)
    exercise.id = id
    exercise.name = name
    exercise.image = image
    exercise.icon = icon
    exercise.meta = Set<Meta>()
    exercise.use = use
    exercise.detection = detection
    
    do {
        try context.save()
        print("Exercise saved")
    } catch {
        print("Failed saving")
    }
}

func deleteExerciseData(_ index: Int) {
    let sortByID = NSSortDescriptor(key: #keyPath(Exercise.id), ascending: true)
    let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    fetchRequest.sortDescriptors = [sortByID]
    fetchRequest.includesPropertyValues = false
    
    do {
        let items = try context.fetch(fetchRequest)
        if items.count > index {
            context.delete(items[index])
        }
        try context.save()
        print("Deleted exercise data successfully")
    } catch {
        print("Failed saving")
    }
}

func clearExerciseData() {
    let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    fetchRequest.includesPropertyValues = false
    
    do {
        let items = try context.fetch(fetchRequest) as [NSManagedObject]
        if items.count > 0 {
            for index in 0..<items.count {
                context.delete(items[index])
            }
            try context.save()
        }
        print("Cleared exercise data successfully")
    } catch {
        print("Failed saving")
    }
}

// interactivity functions
func setUse(exercise: Exercise, use: Bool) {
    exercise.use = use
    
    do {
        try context.save()
        print("Deleted exercise data successfully")
    } catch {
        print("Failed saving")
    }
}

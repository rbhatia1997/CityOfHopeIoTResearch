//
//  MetaData.swift
//  PatientApp
//
//  Created by Darien Joso on 4/4/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import CoreData

// MARK: Stat Data Management
var metas = [Meta]()

func getMetaData(_ sort: [NSSortDescriptor]) -> [Meta] {
    let fetchRequest: NSFetchRequest<Meta> = Meta.fetchRequest()
    fetchRequest.sortDescriptors = sort
    
    do {
        let metaArr = try context.fetch(fetchRequest)
        print("Fetched metadata successfully")
        return metaArr
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    return []
}

func reloadMetaData() {
    metas = getMetaData( [NSSortDescriptor(key: #keyPath(Meta.id), ascending: true)] )
}

func reloadMetaData(_ sort: [NSSortDescriptor]) {
    metas = getMetaData(sort)
}

func addMetaData(id: String, rom: [Float], slouch: Float, comp: Float, exercise: Exercise?, processed: Processed?) {
    let meta = Meta(context: context)
    meta.id = id
    meta.rom = rom
    meta.reps = Int16(rom.count)
    meta.min = rom.min() ?? 0
    meta.max = rom.max() ?? 0
    meta.mean = rom.count == 0 ? 0 : rom.reduce(0, +) / Float(rom.count)
    meta.slouch = slouch
    meta.comp = comp
    exercise?.addToMeta(meta)
    meta.processed = processed
    
    do {
        try context.save()
        print("Meta saved")
    } catch {
        print("Failed saving")
    }
}

func deleteMetaData(_ index: Int) {
    let sortByID = NSSortDescriptor(key: #keyPath(Meta.id), ascending: true)
    let fetchRequest: NSFetchRequest<Meta> = Meta.fetchRequest()
    fetchRequest.sortDescriptors = [sortByID]
    fetchRequest.includesPropertyValues = false
    
    do {
        let items = try context.fetch(fetchRequest)
        if items.count > index {
            if let exercise = items[index].exercise {
                exercise.removeFromMeta(items[index])
            }
            context.delete(items[index])
        }
        try context.save()
        print("Deleted metadata successfully")
    } catch {
        print("Failed saving")
    }
}

func clearMetaData() {
    let fetchRequest: NSFetchRequest<Meta> = Meta.fetchRequest()
    fetchRequest.includesPropertyValues = false
    
    do {
        let items = try context.fetch(fetchRequest)
        if items.count > 0 {
            for index in 0..<items.count {
                context.delete(items[index])
            }
            try context.save()
        }
        print("Cleared metadata successfully")
    } catch {
        print("Failed saving")
    }
}

var exerciseMetas = [[Meta]]()

func getExerciseMetaData() -> [[Meta]] {
    let exerciseArray = getExerciseData([NSSortDescriptor(key: #keyPath(Exercise.id), ascending: true)])
    var metaArrayArray = [[Meta]]()
    for exercise in exerciseArray {
        metaArrayArray.append(Array(exercise.meta))
    }
    
    return metaArrayArray
}

func reloadExerciseMetaData() {
    exerciseMetas.removeAll()
    exerciseMetas = getExerciseMetaData()
    exerciseMetas.append(getNilExerciseMetaData())
}

func getAllExerciseMetaData() -> [[Meta]] {
    let exerciseArray = getAllExerciseData([NSSortDescriptor(key: #keyPath(Exercise.id), ascending: true)])
    var metaArrayArray = [[Meta]]()
    for exercise in exerciseArray {
        metaArrayArray.append(Array(exercise.meta))
    }
    
    return metaArrayArray
}

func reloadAllExerciseMetaData() {
    exerciseMetas.removeAll()
    exerciseMetas = getAllExerciseMetaData()
    exerciseMetas.append(getNilExerciseMetaData())
}

func getNilExerciseMetaData() -> [Meta] {
    let fetchRequest: NSFetchRequest<Meta> = Meta.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "exercise == nil")
    
    do {
        let nilMetaArray = try context.fetch(fetchRequest)
        return nilMetaArray
    } catch {
        print("No data")
    }
    
    return []
}

func deleteExerciseMetaData(_ section: Int, _ row: Int) {
    var metaArrayArray = getAllExerciseMetaData()
    metaArrayArray.append(getNilExerciseMetaData())
    
    if section < metaArrayArray.count {
        if row < metaArrayArray[section].count {
            context.delete(metaArrayArray[section][row])
        }
    }
    
    do {
        try context.save()
        print("Deleted response data successfully")
    } catch {
        print("Failed saving")
    }
}

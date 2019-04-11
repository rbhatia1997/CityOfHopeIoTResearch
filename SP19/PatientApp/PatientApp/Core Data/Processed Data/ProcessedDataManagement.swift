//
//  ProcessedDataManagement.swift
//  PatientApp
//
//  Created by Darien Joso on 4/4/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import CoreData

// MARK: Processed Data Management
var processed = [Processed]()
var exerciseProcessed = [[Processed]]()

func getProcessedData(_ sort: [NSSortDescriptor]) -> [Processed] {
    let fetchRequest: NSFetchRequest<Processed> = Processed.fetchRequest()
    fetchRequest.sortDescriptors = sort
    
    do {
        let processedArr = try context.fetch(fetchRequest)
        print("Fetched processed data successfully")
        return processedArr
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    return []
}

func reloadProcessedData() {
    processed = getProcessedData( [NSSortDescriptor(key: #keyPath(Processed.id), ascending: true)] )
}

func reloadProcessedData(_ sort: [NSSortDescriptor]) {
    processed = getProcessedData( sort )
}

func addProcessedData(id: String, timestep: [Float], q_gb: [[Float]], q_b1: [[Float]], q_b2: [[Float]], q_b3: [[Float]], meta: Meta?) {
    let processed = Processed(context: context)
    processed.id = id
    processed.timestep = timestep
    processed.q_gb = q_gb
    processed.q_b1 = q_b1
    processed.q_b2 = q_b2
    processed.q_b3 = q_b3
    processed.meta = meta
    
    do {
        try context.save()
        print("Meta saved")
    } catch {
        print("Failed saving")
    }
}

func deleteProcessedData(_ index: Int) {
    let sortByID = NSSortDescriptor(key: #keyPath(Processed.id), ascending: true)
    let fetchRequest: NSFetchRequest<Processed> = Processed.fetchRequest()
    fetchRequest.sortDescriptors = [sortByID]
    fetchRequest.includesPropertyValues = false
    
    do {
        let items = try context.fetch(fetchRequest)
        if items.count > index {
            context.delete(items[index])
        }
        try context.save()
        print("Deleted processed data successfully")
    } catch {
        print("Failed saving")
    }
}

func clearProcessedData() {
    let fetchRequest: NSFetchRequest<Processed> = Processed.fetchRequest()
    fetchRequest.includesPropertyValues = false
    
    do {
        let items = try context.fetch(fetchRequest)
        if items.count > 0 {
            for index in 0..<items.count {
                context.delete(items[index])
            }
            try context.save()
        }
        print("Cleared processed data successfully")
    } catch {
        print("Failed saving")
    }
}

func getExerciseProcessedData() -> [[Processed]] {
    var metaArrayArray = getExerciseMetaData()
    metaArrayArray.append(getNilExerciseMetaData())
    var processedArrayArray = [[Processed]]()
    var processedArray = [Processed]()
    
    for array in metaArrayArray {
        processedArray.removeAll()
        for item in array {
            if let processedItem = item.processed {
                processedArray.append(processedItem)
            }
        }
        processedArrayArray.append(processedArray)
    }
    
    return processedArrayArray
}

func reloadExerciseProcessedData() {
    exerciseProcessed.removeAll()
    exerciseProcessed = getExerciseProcessedData()
    exerciseProcessed.append(getNilMetaProcessedData())
}

func getAllExerciseProcessedData() -> [[Processed]] {
    var metaArrayArray = getAllExerciseMetaData()
    metaArrayArray.append(getNilExerciseMetaData())
    var processedArrayArray = [[Processed]]()
    var processedArray = [Processed]()
    
    for array in metaArrayArray {
        processedArray.removeAll()
        for item in array {
            if let processedItem = item.processed {
                processedArray.append(processedItem)
            }
        }
        processedArrayArray.append(processedArray)
    }
    
    return processedArrayArray
}

func reloadAllExerciseProcessedData() {
    exerciseProcessed.removeAll()
    exerciseProcessed = getAllExerciseProcessedData()
    exerciseProcessed.append(getNilMetaProcessedData())
}

func getNilMetaProcessedData() -> [Processed] {
    let fetchRequest: NSFetchRequest<Processed> = Processed.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "meta == nil")
    
    do {
        let nilProcessedArray = try context.fetch(fetchRequest)
        return nilProcessedArray
    } catch {
        print("No data")
    }
    
    return []
}

func deleteExerciseProcessedData(_ section: Int, _ row: Int) {
    var processedArrayArray = getAllExerciseProcessedData()
    processedArrayArray.append(getNilMetaProcessedData())
    
    if section < processedArrayArray.count {
        if row < processedArrayArray[section].count {
            context.delete(processedArrayArray[section][row])
        }
    }
    
    do {
        try context.save()
        print("Deleted response data successfully")
    } catch {
        print("Failed saving")
    }
}

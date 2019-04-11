//
//  GoalDataManagement.swift
//  PatientApp
//
//  Created by Darien Joso on 4/4/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import CoreData

// MARK: Goal Data Management
var goals = [Goal]()

func getGoalData(_ sort: [NSSortDescriptor]) -> [Goal] {
    let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
    fetchRequest.sortDescriptors = sort
    
    do {
        let goalArr = try context.fetch(fetchRequest)
        print("Fetched goal data successfully")
        return goalArr
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    return []
}

func reloadGoalData() {
    goals = getGoalData( [NSSortDescriptor(key: #keyPath(Goal.id), ascending: true)] )
}

func reloadGoalData(_ sort: [NSSortDescriptor]) {
    goals = getGoalData(sort)
}

func addGoalData(id: String, text: String, bool: Bool) {
    let goal = Goal(context: context)
    goal.id = id
    goal.text = text
    goal.bool = bool
    
    do {
        try context.save()
        print("Goal saved")
    } catch {
        print("Failed saving")
    }
}

func deleteGoalData(_ index: Int) {
    let sortByID = NSSortDescriptor(key: #keyPath(Goal.id), ascending: true)
    let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
    fetchRequest.sortDescriptors = [sortByID]
    fetchRequest.includesPropertyValues = false
    
    do {
        let items = try context.fetch(fetchRequest)
        if items.count > index {
            context.delete(items[index])
        }
        try context.save()
        print("Deleted goal data successfully")
    } catch {
        print("Failed saving")
    }
}

func clearGoalData() {
    let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
    fetchRequest.includesPropertyValues = false
    
    do {
        let items = try context.fetch(fetchRequest)
        if items.count > 0 {
            for index in 0..<items.count {
                context.delete(items[index])
            }
            try context.save()
        }
        print("Cleared goal data successfully")
    } catch {
        print("Failed saving")
    }
}

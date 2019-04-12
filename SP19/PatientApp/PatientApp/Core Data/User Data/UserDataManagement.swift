//
//  UserDataManagement.swift
//  PatientApp
//
//  Created by Darien Joso on 4/4/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import CoreData

var username = "Jane"
var baseline = [[10, 120], [10, 120], [10, 120], [10, 120], [10, 120]]
var exerciseSelection = ["Front Arm Raise", "Side Arm Raise", "Medicine Ball Overhead Circles", "Arnold Shoulder Press", "Dumbell Shoulder Press"]
var usersex = "F"
var userage = 50

var user: User!
var userData = [String]()

func createDefaultUser() {
    let us = User(context: context)
    us.age = 0
    us.name = "Jane Doe"
    us.sex = "Anything"
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    us.startDate = formatter.date(from: "1900/06/09")!
    
    do {
        try context.save()
        print("Default User created saved")
    } catch {
        print("Failed saving")
    }
}

func clearAllUsers() {
    let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
    fetchRequest.includesPropertyValues = false
    
    do {
        let items = try context.fetch(fetchRequest) as [NSManagedObject]
        if items.count > 0 {
            for index in 0..<items.count {
                context.delete(items[index])
            }
            try context.save()
        }
        print("Cleared User data successfully")
    } catch {
        print("Failed saving")
    }
}

func reloadUser() {
    let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
    
    do {
        let userArray = try context.fetch(fetchRequest)
        if userArray.count == 1 {
            user = userArray[0]
            print("User saved")
        } else {
            print("There are \(userArray.count) User accounts")
            clearAllUsers()
            createDefaultUser()
        }
    } catch {
        print("Failed to fetch user")
    }
}

func getUserData() {
    userData.removeAll()
    reloadUser()
    userData.append(user.name)
    userData.append(String(user.age))
    userData.append(user.sex)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd, yyyy"
    userData.append(dateFormatter.string(from: user.startDate))
    print("User info updated")
}

//
//  TableViewCell.swift
//  PatientApp
//
//  Created by Darien Joso on 3/25/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import CoreData

// overall core data context
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

// just a large number used to set the values of the 
let largeNumber: Int = 10000

func generateID() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "PST")
    formatter.dateFormat = "yyyyMMddhhmmssSSS"
    return formatter.string(from: date)
}

func saveContext() {
    do {
        try context.save()
        print("Context saved")
    } catch {
        print("Failed saving")
    }
}

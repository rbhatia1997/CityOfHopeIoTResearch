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
let largeNumber: Int = 1000000000

func generateID() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMddHHmmssSSS"
    return formatter.string(from: date)
}

func getDate(_ string: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMddHHmmssSSS"
    return formatter.date(from: string)!
}

func convertFormatFromID(id: String, format: String) -> String {
    let date = getDate(id)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func saveContext() {
    do {
        try context.save()
        print("Context saved")
    } catch {
        print("Failed saving")
    }
}

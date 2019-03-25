//
//  Goal+CoreDataProperties.swift
//  PatientApp
//
//  Created by Darien Joso on 3/24/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//
//

import Foundation
import CoreData

extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var achieved: Bool
    @NSManaged public var entry: String?
    @NSManaged public var date: Date

}

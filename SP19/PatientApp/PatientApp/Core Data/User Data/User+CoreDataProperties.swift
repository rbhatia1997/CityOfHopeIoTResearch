//
//  User+CoreDataProperties.swift
//  PatientApp
//
//  Created by Darien Joso on 4/12/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var age: Int16
    @NSManaged public var name: String
    @NSManaged public var sex: String
    @NSManaged public var startDate: Date

}

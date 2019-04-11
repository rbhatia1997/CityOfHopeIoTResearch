//
//  Question+CoreDataProperties.swift
//  PatientApp
//
//  Created by Darien Joso on 4/4/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//
//

import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    @NSManaged public var id: String
    @NSManaged public var bool: Bool
    @NSManaged public var text: String
    @NSManaged public var response: Set<Response>

}

// MARK: Generated accessors for response
extension Question {

    @objc(addResponseObject:)
    @NSManaged public func addToResponse(_ value: Response)

    @objc(removeResponseObject:)
    @NSManaged public func removeFromResponse(_ value: Response)

    @objc(addResponse:)
    @NSManaged public func addToResponse(_ values: NSSet)

    @objc(removeResponse:)
    @NSManaged public func removeFromResponse(_ values: NSSet)

}

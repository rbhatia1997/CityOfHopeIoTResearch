//
//  WellnessQuestion+CoreDataProperties.swift
//  PatientApp
//
//  Created by Darien Joso on 3/26/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//
//

import Foundation
import CoreData


extension WellnessQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WellnessQuestion> {
        return NSFetchRequest<WellnessQuestion>(entityName: "WellnessQuestion")
    }

    @NSManaged public var isSlider: Bool
    @NSManaged public var question: String
    @NSManaged public var date: Date
    @NSManaged public var wellnessResponse: WellnessResponse?

}

// MARK: Generated accessors for wellnessResponse
extension WellnessQuestion {

    @objc(addWellnessResponseObject:)
    @NSManaged public func addToWellnessResponse(_ value: WellnessResponse)

    @objc(removeWellnessResponseObject:)
    @NSManaged public func removeFromWellnessResponse(_ value: WellnessResponse)

    @objc(addWellnessResponse:)
    @NSManaged public func addToWellnessResponse(_ values: NSSet)

    @objc(removeWellnessResponse:)
    @NSManaged public func removeFromWellnessResponse(_ values: NSSet)

}

//
//  WellnessResponse+CoreDataProperties.swift
//  PatientApp
//
//  Created by Darien Joso on 3/26/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//
//

import Foundation
import CoreData


extension WellnessResponse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WellnessResponse> {
        return NSFetchRequest<WellnessResponse>(entityName: "WellnessResponse")
    }

    @NSManaged public var date: Date
    @NSManaged public var yesNoResult: Bool
    @NSManaged public var sliderResult: Float
    @NSManaged public var wellnessQuestion: WellnessQuestion

}

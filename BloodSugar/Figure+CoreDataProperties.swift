//
//  Figure+CoreDataProperties.swift
//  BloodSugar
//
//  Created by Jenny Swift on 24/4/19.
//  Copyright © 2019 Jenny Swift. All rights reserved.
//
//

import Foundation
import CoreData


extension Figure {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Figure> {
        return NSFetchRequest<Figure>(entityName: "Figure")
    }

    @NSManaged public var bloodSugarStart: Double
    @NSManaged public var bloodSugarGoal: Double
    @NSManaged public var totalNetCarbs: Double
    @NSManaged public var totalMinutesWalking: Double
    @NSManaged public var netCarbsPerInsulinUnit: Double
    @NSManaged public var totalInsulin: Double
    @NSManaged public var bloodSugarEnd: Double
    @NSManaged public var correctionFactor: Double

}

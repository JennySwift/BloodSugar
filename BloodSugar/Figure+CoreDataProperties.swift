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

    @NSManaged public var name: String
    @NSManaged public var value: Double
}

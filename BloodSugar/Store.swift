//
//  Store.swift
//  BloodSugar
//
//  Created by Jenny Swift on 17/4/19.
//  Copyright © 2019 Jenny Swift. All rights reserved.
//

import Foundation

class Store {
    static let shared = Store()
    static var totalNetCarbs: Double = 0.0
    
    static func setTotalNetCarbs(total: Decimal) {
        totalNetCarbs = Helpers.decimalToDouble(decimal: total)
//        totalNetCarbs = total
    }
}

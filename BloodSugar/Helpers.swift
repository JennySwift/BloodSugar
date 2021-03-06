//
//  Helpers.swift
//  BloodSugar
//
//  Created by Jenny Swift on 24/1/19.
//  Copyright © 2019 Jenny Swift. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class Helpers {
    
    static func decimalToDouble(decimal: Decimal) -> Double {
        return Double(decimal as NSNumber)
    }
    
    // Given the number 843.19...
    // If x = 1, result will be 843
    // If x = 10, result will be 843.2
    // If x = 100, result will be 843.19
    static func roundValue(_ value: Decimal, x: Decimal) -> Decimal {
        var newValue = value
        newValue *= x
        newValue = Decimal(round(Helpers.decimalToDouble(decimal: newValue)))
        newValue /= x
        
        return newValue
    }
    
    // Given the number 843.19...
    // If x = 1, result will be 843
    // If x = 10, result will be 843.2
    // If x = 100, result will be 843.19
    static func roundDouble(_ value: Double, x: Double) -> Double {
        var newValue = value
        newValue *= x
        newValue = round(newValue)
        newValue /= x
        
        return newValue
    }
    
    static func stringToDecimal(string: String) -> NSDecimalNumber {
        return NSDecimalNumber(string: string)
    }
    
    static func intToDecimal(int: Int64) -> NSDecimalNumber {
        return Helpers.stringToDecimal(string: String(int))
    }
    
    static func int64ToInt32(int64: Int64) -> Int32 {
        return Int32(exactly: int64) ?? 0
    }
    
    static func decimalToString(decimal: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let value = formatter.string(from: NSDecimalNumber(decimal: decimal)) ?? ""
        return value
    }
    
    static func decimalNumberToString(decimal: NSDecimalNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let value = formatter.string(from: decimal) ?? ""
        return value
    }
    
    static func playSound() -> Void {
        AudioServicesPlaySystemSound(1103)
    }
    
    static func copyToClipboard(string: String) -> Void {
        UIPasteboard.general.string = string
    }
}

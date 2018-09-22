//
//  File.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/21/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import Foundation

class Util {
    static func GetValueAsCurrencyString(_ f: Float) -> String {
        return String(format: "$%.02f", f)
    }
    
    static func GetValueAsPercentString(_ f: Float) -> String {
        return String(format: "%.02f%%", f)
    }
    
    static func FormatDate(_ date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY hh:mm a"
        return dateFormatter.string(from: date)
    }
}

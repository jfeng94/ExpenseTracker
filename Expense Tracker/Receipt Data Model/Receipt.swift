//
//  Receipt.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/18/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class Receipt {
    //MARK: Properties
    var vendorName : String
    var items : [Item] = []
    
    init(vendorName: String, items: [Item]) {
        self.vendorName = vendorName;
        self.items += items;
    }
    
    func GetTotalCost() -> Float {
        var sum = Float(0);
        for item in items {
            sum += item.GetTotalCost()
        }
        
        return sum;
    }
    
    func GetTotalCostAsString() -> String {
        return String(format: "$%.02f", GetTotalCost())
    }
    
    func GetSharerIDs() -> [String] {
        let peopleMap = NSMutableSet()
        var sharers = [String]()
        for item in items {
            for sharer in item.sharers {
                if (!peopleMap.contains(sharer)) {
                    peopleMap.add(sharer)
                    sharers += [sharer]
                }
            }
        }
        
        return sharers
    }
    
    func GetSharerCost(sharer: String) -> Float {
        var sum = Float(0)
        for item in items {
            sum += item.GetSharerCost(sharer: sharer)
        }
        
        return sum
    }
    
    func GetSharerCostAsString(sharer: String) -> String {
        return String(format: "$%.02f", GetSharerCost(sharer: sharer))
    }
}

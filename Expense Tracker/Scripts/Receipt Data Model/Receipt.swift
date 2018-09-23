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
    var date : Date
    
    init(vendorName: String, items: [Item], date: Date) {
        self.vendorName = vendorName;
        self.items += items;
        self.date = date;
    }
    
    
    ////////////////////////
    // MARK: Cost stats
    ////////////////////////
    func GetTotalCost() -> Float {
        var sum = Float(0);
        for item in items {
            sum += item.GetTotalCost()
        }
        
        return sum;
    }
    
    func GetTotalCostAsString() -> String {
        return Util.GetValueAsCurrencyString(GetTotalCost())
    }
    
    ////////////////////////
    // MARK: Sharer stats
    ////////////////////////
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
        return Util.GetValueAsCurrencyString(GetSharerCost(sharer: sharer))
    }
    
    func GetUnaccountedCost() -> Float {
        var sum = Float(0)
        for item in items {
            sum += item.GetUnaccountedCost()
        }
        
        return sum
        
    }
    
    func GetUnaccountedCostAsString() -> String {
        return Util.GetValueAsCurrencyString(GetUnaccountedCost())
    }
    
    ////////////////////////
    // MARK: Tax methods
    ////////////////////////
    func GetGlobalTax() -> Float? {
        if (items.count > 0) {
            let tax = items[0].tax
            for i in 1...(items.count - 1) {
                if tax != items[i].tax {
                    return nil
                }
            }
            
            return tax
        }
        return 0
    }
    
    func SetGlobalTax(_ tax: Float) {
        for item in items {
            item.tax = tax
        }
    }
    
    
    ////////////////////////
    // MARK: Tip methods
    ////////////////////////
    func GetGlobalTip() -> Float? {
        if (items.count > 0) {
            let tip = items[0].tip
            for i in 1...(items.count - 1) {
                if tip != items[i].tip {
                    return nil
                }
            }
            
            return tip
        }
        return 0
    }
    
    func SetGlobalTip(_ tip: Float) {
        for item in items {
            item.tip = tip
        }
    }
}

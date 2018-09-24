//
//  Item.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/18/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import Foundation

class Item {
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Properties
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    var name:         String
    var note:         String
    var price:        Float
    var tax:          Float // As a percentage. Aka 9.25% => 0.0925
    var tip:          Float // As a percentage. Aka 20% => 0.2
    var sharers:     [Int]
    var sharerBuys =  NSMutableDictionary()
    var sortingTag:   String
    
    static var defaultTax = Float(9.25)
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Initialization
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Convenience initializer
    init(name: String) {
        self.name = name
        self.note = ""
        self.price = 0
        self.tax = Item.defaultTax
        self.tip = 0.0
        self.sharers = []
        self.sortingTag = "";
    }
    
    // Explicit initialization
    init(name: String, note: String, price: Float, tax: Float, tip: Float, sortingTag: String, sharers: [Int], sharerBuys: NSMutableDictionary) {
        self.name = name
        self.note = note
        self.price = price
        self.tax = tax
        self.tip = tip
        self.sharers = []
        self.sharers += sharers
        self.sortingTag = sortingTag
        self.sharerBuys = sharerBuys
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Convenience methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func GetNumUnits() -> Int {
        var num = 0
        for id in sharers {
            if let numBought = sharerBuys[id] as? Int {
                num = num + numBought
            }
        }
        return num
    }
    
    func GetUnitCost() -> Float {
        return price * (1 + (tax / 100) + (tip / 100))
    }
    
    func GetTotalCost() -> Float {
        return GetUnitCost() * Float(GetNumUnits())
    }
    
    func GetPriceAsString() -> String {
        return Util.GetValueAsCurrencyString(self.price)
    }
    
    func GetTotalCostAsString() -> String {
        return Util.GetValueAsCurrencyString(GetTotalCost())
    }
    
    
    func GetTaxAsString() -> String {
        return Util.GetValueAsPercentString(self.tax)
    }
    
    func GetTipAsString() -> String {
        return Util.GetValueAsPercentString(self.tip)
    }
    
    func GetSharerCost(sharer: Int) -> Float {
        if (sharer == PersonManager.voidPersonID) {
            return GetUnaccountedCost()
        }
        
        for personID in sharers {
            if (personID == sharer) {
                if let num = sharerBuys[sharer] as? Int {
                    return GetUnitCost() * Float(num)
                }
            }
        }
        return 0
    }
    
    func GetUnaccountedCost() -> Float {
        if sharers.count == 0 {
            return GetTotalCost()
        }
        
        return Float(0)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Sharer methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func setSharerBuys(sharer: Int, numBought: Int) {
        var canAdd = true;
        
        if (sharers.count != 0) {
            for i in 0...sharers.count - 1 {
                if (sharers[i] == sharer) {
                    canAdd = false;
                    break;
                }
            }
        }
        
        if (canAdd) {
            sharers.append(sharer)
        }
        
        sharerBuys[sharer] = numBought
    }
    
    func removeSharer(sharer: Int) {
        var toRemove = -1;
        
        if (sharers.count != 0) {
            for i in 0...sharers.count - 1 {
                if (sharers[i] == sharer) {
                    toRemove = i
                }
            }
        }
        
        if (toRemove != -1) {
            sharers.remove(at: toRemove);
            sharerBuys.removeObject(forKey: sharer)
        }
    }
}

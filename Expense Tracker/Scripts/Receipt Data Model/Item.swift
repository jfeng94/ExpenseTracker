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
    var name:       String
    var note:       String
    var price:      Float
    var numUnits:   Int
    var tax:        Float // As a percentage. Aka 9.25% => 0.0925
    var tip:        Float // As a percentage. Aka 20% => 0.2
    var sharers:   [String]
    var sortingTag: String
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Initialization
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Convenience initializer
    init(name: String) {
        self.name = name
        self.note = ""
        self.price = 0
        self.numUnits = 1
        self.tax = 0.0
        self.tip = 0.0
        self.sharers = []
        self.sortingTag = "";
    }
    
    // Explicit initialization
    init(name: String, note: String, price: Float, numUnits: Int, tax: Float, tip: Float, sortingTag: String, sharers: [String]) {
        self.name = name
        self.note = note
        self.price = price
        self.numUnits = numUnits
        self.tax = tax
        self.tip = tip
        self.sharers = []
        self.sharers += sharers
        self.sortingTag = sortingTag
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Convenience methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func GetTotalCost() -> Float {
        return (price * Float(numUnits) * (1 + (tax / 100) + (tip / 100)))
    }
    
    func GetPriceAsString() -> String {
        return String(format: "$%.02f", self.price)
    }
    
    func GetTotalCostAsString() -> String {
        return String(format: "$%.02f", GetTotalCost())
    }
    
    
    func GetTaxAsString() -> String {
        return String(format: "%.02f%%", self.tax)
    }
    
    func GetTipAsString() -> String {
        return String(format: "%.02f%%", self.tip)
    }
    
    func GetSharerCost(sharer: String) -> Float {
        for personID in sharers {
            if (personID == sharer) {
                return GetTotalCost() / Float(sharers.count)
            }
        }
        return 0
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Sharer methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func addSharer(sharer: String) {
        var canAdd = true;
        
        for i in 0...sharers.count {
            if (sharers[i] == sharer) {
                canAdd = false;
                break;
            }
        }
        
        if (canAdd) {
            sharers.append(sharer)
        }
    }
    
    func removeSharer(sharer: String) {
        var toRemove = -1;
        for i in 0...sharers.count {
            if (sharers[i] == sharer) {
                toRemove = i
            }
        }
        
        if (toRemove != -1) {
            sharers.remove(at: toRemove);
        }
    }
}
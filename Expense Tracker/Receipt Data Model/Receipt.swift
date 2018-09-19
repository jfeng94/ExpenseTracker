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
}

//
//  ItemDetailsTableViewCell.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/18/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class ItemDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var basePrice: UILabel!
    @IBOutlet weak var taxRate: UILabel!
    @IBOutlet weak var tipRate: UILabel!
    @IBOutlet weak var sortingTag: UILabel!
    @IBOutlet weak var subtotal: UILabel!
    
    func configure(item: Item) {
              name.text =                item.name;
         basePrice.text =    "Price: " + item.GetPriceAsString()
           taxRate.text =      "Tax: " + item.GetTaxAsString()
           tipRate.text =      "Tip: " + item.GetTipAsString()
        sortingTag.text =      "Tag: " + item.sortingTag
          subtotal.text = "Subtotal: " + item.GetTotalCostAsString()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

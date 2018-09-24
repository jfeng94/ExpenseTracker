//
//  ItemDetailsTableViewCell.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/18/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class ItemDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var priceAndNum: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var tip: UILabel!
    @IBOutlet weak var sortingTag: UILabel!
    @IBOutlet weak var subtotal: UILabel!
    
    func configure(item: Item) {
              name.text = item.name
              note.text = item.note
       priceAndNum.text = item.GetPriceAsString() + " × " + String(item.GetNumUnits())
               tax.text = item.GetTaxAsString()
               tip.text = item.GetTipAsString()
        sortingTag.text = item.sortingTag
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

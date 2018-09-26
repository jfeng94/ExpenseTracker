//
//  ReceiptTableViewCell.swift
//  Cleaver
//
//  Created by Jerry Feng on 9/26/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class ReceiptTableViewCell: UITableViewCell {
    @IBOutlet weak var vendorName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

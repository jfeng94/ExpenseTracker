//
//  ItemSharerTableViewCell.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/18/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class NewItemSharerViewCell: UITableViewCell {
    var sharerID : Int!
    var item: Item!
    var controller: NewItemViewController!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var sharerName: UILabel!
    @IBOutlet weak var sharerPrice: UILabel!
    @IBOutlet weak var numShares: UILabel!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    func configure(sharerID: Int, item: Item, controller: NewItemViewController) {
        self.sharerID   = sharerID
        self.item       = item
        self.controller = controller
        
        plusButton.addTarget(self, action:
            #selector(self.incrementItem(button:)), for:
            .touchUpInside)
        
        minusButton.addTarget(self, action:
            #selector(self.decrementItem(button:)), for:
            .touchUpInside)
        
        updateFields()
    }
    
    private func updateFields() {
        profileImage.image = PersonManager.instance.GetPhoto(ID: sharerID)
        sharerName.text = PersonManager.instance.GetName(ID: sharerID)
        sharerPrice.text = Util.GetValueAsCurrencyString(item.GetSharerCost(sharer: sharerID))
        numShares.text = String(item.GetNumShares(ID: sharerID))
    }
    
    @objc func incrementItem(button: UIButton) {
        print("INCREMENT")
        item.incrementSharerBuys(sharer: sharerID)
        
        updateFields()
        
        controller.reloadData()
    }
    
    @objc func decrementItem(button: UIButton) {
        print("decrement")
        item.decrementSharerBuys(sharer: sharerID)
        
        updateFields()
        
        controller.reloadData()
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

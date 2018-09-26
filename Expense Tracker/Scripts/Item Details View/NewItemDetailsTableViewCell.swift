//
//  NewItemDetailsTableViewCell.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/25/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class NewItemDetailsTableViewCell: UITableViewCell, UITextFieldDelegate {
    var item: Item!
    var controller: NewItemViewController!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var tax: UITextField!
    @IBOutlet weak var tip: UITextField!
    @IBOutlet weak var sortingTag: UITextField!
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: TableViewCell Methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func configure(item: Item, controller: NewItemViewController) {
        self.item = item
        self.controller = controller
        
        // Initialization code
        var i = 0
        name.delegate       = self; name.tag       = i; i = i + 1
        notes.delegate      = self; notes.tag      = i; i = i + 1
        price.delegate      = self; price.tag      = i; i = i + 1
        tax.delegate        = self; tax.tag        = i; i = i + 1
        tip.delegate        = self; tip.tag        = i; i = i + 1
        sortingTag.delegate = self; sortingTag.tag = i; i = i + 1
        
        name.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        price.keyboardType = .decimalPad
        tax.keyboardType   = .decimalPad
        tip.keyboardType   = .decimalPad
        
        updateFields()
        controller.updateSaveButtonState()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: UITextFieldDelegate methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == price || textField == tax || textField == tip) {
            if (textField.text == "0.00") {
                textField.text = ""
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateItem()
        updateFields()
        controller.updateSaveButtonState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateItem()
        updateFields()
        controller.updateSaveButtonState()
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        controller.view.endEditing(true);
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Private methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    private func updateFields() {
        if (item != nil) {
            name.text       = item.name
            notes.text      = item.note
            price.text      = Util.Format2Dec(item.price)
            tax.text        = Util.Format2Dec(item.tax)
            tip.text        = Util.Format2Dec(item.tip)
            sortingTag.text = item.sortingTag
        }
        else {
            fatalError("No item!")
        }
    }
    
    private func updateItem() {
        if (item != nil) {
            if let s = name.text {
                item.name = s
            }
            
            if let s = notes.text {
                item.note = s
            }
            
            if let s = price.text {
                if let p = Float(s) {
                    item.price = p
                }
                else if (s.isEmpty) {
                    item.price = Float(0);
                }
            }
            if let s = tax.text {
                if let t = Float(s) {
                    item.tax = t
                }
                else if (s.isEmpty) {
                    item.tax = Float(0);
                }
            }
            
            if let s = tip.text {
                if let t = Float(s) {
                    item.tip = t
                }
                else if (s.isEmpty) {
                    item.tip = Float(0);
                }
            }
            
            if let s = sortingTag.text {
                item.sortingTag = s
            }
        }
    }
    
}

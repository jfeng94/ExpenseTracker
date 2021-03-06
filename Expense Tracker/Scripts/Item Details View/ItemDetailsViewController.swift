//
//  ItemDetailsViewController.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/21/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var tax: UITextField!
    @IBOutlet weak var tip: UITextField!
    @IBOutlet weak var tag: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ReceiptVendorDetailsViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        var i = 0
        name.delegate  = self; name.tag  = i; i = i + 1
        notes.delegate = self; notes.tag = i; i = i + 1
        price.delegate = self; price.tag = i; i = i + 1
        tax.delegate   = self; tax.tag   = i; i = i + 1
        tip.delegate   = self; tip.tag   = i; i = i + 1
        tag.delegate   = self; tag.tag   = i; i = i + 1
        
        name.addTarget(self, action: #selector(ItemDetailsViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        price.keyboardType = .decimalPad
        tax.keyboardType   = .decimalPad
        tip.keyboardType   = .decimalPad
        
        if (saveButton != nil) {
            saveButton.isEnabled = false
        }
        updateFields()
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
        updateSaveButtonState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateItem()
        updateFields()
        updateSaveButtonState()
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true);
    }
    
    // MARK: Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: Private methods
    private func updateSaveButtonState() {
        if (saveButton != nil) {
            let text = name.text ?? ""
            saveButton.isEnabled = !text.isEmpty
        }
    }

    private func updateFields() {
        if (item != nil) {
            name.text  = item.name
            notes.text = item.note
            price.text = Util.Format2Dec(item.price)
            tax.text   = Util.Format2Dec(item.tax)
            tip.text   = Util.Format2Dec(item.tip)
            tag.text   = item.sortingTag
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
            
            if let s = tag.text {
                item.sortingTag = s
            }
        }
    }
    
    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//
//        switch(segue.identifier ?? "") {
//        case "save":
//            guard let itemTableViewController = segue.destination as? ItemTableViewController else {
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//
//            itemTableViewController.item = item
//
//            if (sender as? UIBarButtonItem == saveButton) {
//                if let prevScreen = navigationController?.popViewController(animated: false) as? ReceiptTableViewController {
//                    prevScreen.addToReceipt(item: item)
//                }
//            }
//
//        default:
//            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
//        }
//
//    }

}

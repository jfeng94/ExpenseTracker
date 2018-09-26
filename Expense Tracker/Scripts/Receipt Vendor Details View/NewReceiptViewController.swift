//
//  ReceiptVendorDetailsViewController.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/20/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class NewReceiptViewController: ReceiptVendorDetailsViewController {
    var controller: ReceiptHistoryTableViewController!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vendorName.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        refreshFields()
        updateSaveButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        receipt = Receipt.init(vendorName: "", items: [], date: Date.init())
        
        refreshFields()
        super.viewWillAppear(animated)
    }
    
    func updateSaveButton() {
        if ((vendorName.text ?? "").isEmpty) {
            saveButton.isEnabled = false
        }
        else {
            saveButton.isEnabled = true
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateSaveButton()
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        
        refreshFields()
        updateSaveButton()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Actions
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "receiptSaved":
            refreshReceipt()
            controller.addReceipt(receipt)
            
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier)) from \(String(describing: sender.debugDescription))")
        }
    }
    
}

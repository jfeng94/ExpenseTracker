//
//  ReceiptVendorDetailsViewController.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/20/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class ReceiptVendorDetailsViewController: UIViewController, UITextFieldDelegate {
    var receipt: Receipt!
    @IBOutlet weak var vendorName: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var tax: UITextField!
    @IBOutlet weak var tip: UITextField!
    
    private var datePicker : UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var i = 0
        vendorName.delegate = self; vendorName.tag = i; i = i + 1
              date.delegate = self;       date.tag = i; i = i + 1
               tax.delegate = self;        tax.tag = i; i = i + 1
               tip.delegate = self;        tip.tag = i; i = i + 1
        
        tax.keyboardType = .decimalPad
        tip.keyboardType = .decimalPad
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime;
        datePicker.addTarget(self, action: #selector(ReceiptVendorDetailsViewController.dateChanged(datePicker:)), for: .valueChanged)
        date.inputView = datePicker
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ReceiptVendorDetailsViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        refreshFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true);
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        receipt.date = datePicker.date
        refreshFields()
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
        if (textField == tax || textField == tip) {
            if (textField.text == "0.00") {
                textField.text = ""
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (receipt != nil) {
            if let s = vendorName.text {
                receipt.vendorName = s
            }
            
            if let s = tax.text {
                if let t = Float(s) {
                    receipt.SetGlobalTax(t)
                }
                else if (s.isEmpty) {
                    // It's empty. Let's set it to 0
                    receipt.SetGlobalTax(Float(0));
                }
            }
            
            if let s = tip.text {
                if let t = Float(s) {
                    receipt.SetGlobalTip(t)
                }
                else if (s.isEmpty) {
                    // It's empty. Let's set it to 0
                    receipt.SetGlobalTip(Float(0))
                }
            }
            
            refreshFields();
        }
    }
    
    private func refreshFields() {
        if (receipt != nil) {
            vendorName.text = receipt.vendorName
            
            date.text = Util.FormatDate(receipt.date)
            
            if let globalTip = receipt.GetGlobalTip() {
                tip.text = Util.Format2Dec(globalTip);
            }
            else {
                tip.text = "mixed"
            }
            
            if let globalTax = receipt.GetGlobalTax() {
                tax.text = Util.Format2Dec(globalTax);
            }
            else {
                tax.text = "mixed"
            }
        }

    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

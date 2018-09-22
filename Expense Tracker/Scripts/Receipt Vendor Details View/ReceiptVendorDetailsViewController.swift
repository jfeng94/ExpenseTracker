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
        
        vendorName.delegate = self
        date.delegate = self
        tax.delegate = self
        tip.delegate = self
        
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
        textField.resignFirstResponder()
        
        return true
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
                tip.text = String(globalTip);
            }
            else {
                tip.text = "mixed"
            }
            
            if let globalTax = receipt.GetGlobalTax() {
                tax.text = String(globalTax);
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

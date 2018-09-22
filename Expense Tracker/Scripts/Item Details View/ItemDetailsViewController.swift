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
    @IBOutlet weak var num: UITextField!
    @IBOutlet weak var tax: UITextField!
    @IBOutlet weak var tip: UITextField!
    @IBOutlet weak var tag: UITextField!
    
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        notes.delegate = self
        price.delegate = self
        num.delegate = self
        tax.delegate = self
        tip.delegate = self
        tag.delegate = self
        
        price.keyboardType = .numberPad
        num.keyboardType   = .numberPad
        tax.keyboardType   = .numberPad
        tip.keyboardType   = .numberPad
        
        if (item != nil) {
            name.text  = item.name
            notes.text = item.note
            price.text = String(item.price)
            num.text   = String(item.numUnits)
            tax.text   = String(item.tax)
            tip.text   = String(item.tip)
            tag.text   = item.sortingTag
        }
        else {
            fatalError("No item!")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
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
        
        if let s = num.text {
            if let n = Int(s) {
                item.numUnits = n
            }
            else if (s.isEmpty) {
                item.numUnits = Int(0);
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
        
        name.text  = item.name
        notes.text = item.note
        price.text = String(item.price)
        num.text   = String(item.numUnits)
        tax.text   = String(item.tax)
        tip.text   = String(item.tip)
        tag.text   = item.sortingTag
        
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

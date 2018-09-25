//
//  ItemDetailsViewController.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/21/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var tax: UITextField!
    @IBOutlet weak var tip: UITextField!
    @IBOutlet weak var tag: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var table: UITableView!
    
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewItemViewController.viewTapped(gestureRecognizer:)))
//        
//        view.addGestureRecognizer(tapGesture)
        
        var i = 0
        name.delegate  = self; name.tag  = i; i = i + 1
        notes.delegate = self; notes.tag = i; i = i + 1
        price.delegate = self; price.tag = i; i = i + 1
        tax.delegate   = self; tax.tag   = i; i = i + 1
        tip.delegate   = self; tip.tag   = i; i = i + 1
        tag.delegate   = self; tag.tag   = i; i = i + 1
        
        name.addTarget(self, action: #selector(NewItemViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        price.keyboardType = .decimalPad
        tax.keyboardType   = .decimalPad
        tip.keyboardType   = .decimalPad
        
        if (saveButton != nil) {
            saveButton.isEnabled = false
        }
        updateFields()
        updateSaveButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        table.reloadData()
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
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Actions
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Table View Delegate Methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.sharers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row < item.sharers.count) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "itemSharerCell", for: indexPath) as? NewItemSharerViewCell {
                let sharer = item.sharers[indexPath.row]
                cell.configure(sharerID: sharer, item: item, controller: self)
                return cell;
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newSharerCell", for: indexPath)
            return cell;
        }
        
        
        
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == item.sharers.count) {
            return 60
        }
        
        return 100
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.row < item.sharers.count) {
            return true
        }
        return false
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            item.sharers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if (indexPath.row < item.sharers.count) {
//            return nil
//        }
//        return indexPath
//    }

    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Private methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let button = sender as? UIBarButtonItem {
            if (button == saveButton) {
                return
            }
        }
        
        switch(segue.identifier ?? "") {
        case "addNewSharer":
            guard let nextController = segue.destination as? PersonSelectionViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
    
    func addSharer(ID: Int) {
        item.setSharerBuys(sharer: ID, numBought: 1)
    }
    
    func reloadData() {
        table.reloadData()
    }
}

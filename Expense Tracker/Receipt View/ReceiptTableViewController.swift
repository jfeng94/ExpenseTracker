//
//  LogReceiptTableViewController.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/17/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit
import os.log

class ReceiptTableViewController: UITableViewController {
    var receipt: Receipt!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleReceipt()
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    
    //MARK: Private Methods
    func loadSampleReceipt() {
        let photoJerry = UIImage(named: "Jerry")
        let photoGrace = UIImage(named: "Grace")
        let photoTony  = UIImage(named: "Tony")
        
        guard let jerry = Person.init(name: "Jerry", photo: photoJerry) else { fatalError("Unable to instantiate jerry") }
        guard let grace = Person.init(name: "Grace", photo: photoGrace) else { fatalError("Unable to instantiate grace") }
        guard let tony  = Person.init(name: "Tony",  photo: photoTony)  else { fatalError("Unable to instantiate tony") }
        
        let nngt = Item.init(name: "Nom Nom Green Tea", note: "+ Boba",  price: 4.45, numUnits: 2, tax: 9.25, tip: 0.0, sortingTag: "Drink", sharers: [jerry, tony])
        let rmt  = Item.init(name: "Rose Milk Tea",     note: "+ Bobes", price: 4.45, numUnits: 1, tax: 9.25, tip: 0.0, sortingTag: "Life sustinence", sharers: [grace])
        
        receipt = Receipt.init(vendorName: "Factory Tea Bar", items: [nngt, rmt])
    }
    
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows = 2 // Vendor cell, add new item cell.
        
        if (receipt != nil) {
            numRows += receipt.items.count
        }
        
        return numRows;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "vendorCell", for: indexPath) as? VendorTableViewCell {
                cell.vendorLabel.text = "Factory Tea Bar"
                cell.dateLabel.text = "September 17, 2018, 6:09 PM"
                return cell;
            }
        }
        else if (receipt != nil && indexPath.row >= 1 && indexPath.row < receipt.items.count + 1) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell {
                cell.itemLabel.text = receipt.items[indexPath.row - 1].name
                cell.priceLabel.text = receipt.items[indexPath.row - 1].GetTotalCostAsString();
                return cell;
            }
        }
        else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "newItemCell", for: indexPath) as? UITableViewCell {
                return cell;
            }
        }

        // Configure the cell...

        return UITableViewCell()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case "ShowItemDetail":
                guard let itemTableViewController = segue.destination as? ItemTableViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedItemCell = sender as? ItemTableViewCell else {
                    fatalError("Unexpected sender: \(sender)")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedItemCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                itemTableViewController.item = receipt.items[indexPath.row - 1]
        
            case "ShowVendorDetail":
                print("Hi")
            
            default:
                fatalError("Unexpected Segue Identifier: \(segue.identifier)")
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

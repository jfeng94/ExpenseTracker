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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows = 3 // Vendor cell, header, add new item cell.
        
        if (receipt != nil) {
            numRows += receipt.items.count
        }
        
        return numRows;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 100
        }
        if (indexPath.row == 1) {
            return 25
        }
        
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "vendorCell", for: indexPath) as? VendorTableViewCell {
                cell.vendorLabel.text = receipt.vendorName
                cell.dateLabel.text = Util.FormatDate(receipt.date)
                cell.total.text = "Total: " + receipt.GetTotalCostAsString()
                return cell;
            }
        }
        else if (indexPath.row == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
            return cell;
        }
        else if (receipt != nil && indexPath.row >= 2 && indexPath.row < receipt.items.count + 2) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell {
                let item = receipt.items[indexPath.row - 2]
                cell.itemLabel.text = item.name + " × " + String(item.GetNumUnits())
                cell.priceLabel.text = item.GetTotalCostAsString()
                cell.note.text = item.note
                return cell;
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newItemCell", for: indexPath)
            return cell;
        }

        // Configure the cell...

        return UITableViewCell()
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row >= receipt.items.count + 2) {
            return false
        }
        return true
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            receipt.items.remove(at: indexPath.row - 2)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

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
    
    
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewItemViewController, let item = sourceViewController.item {
            let newIndexPath = IndexPath(row: receipt.items.count + 2, section: 0)
            receipt.items.append(item)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
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
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedItemCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                itemTableViewController.item = receipt.items[indexPath.row - 2]
        
            case "ShowVendorDetail":
                guard let receiptVendorDetailsViewController = segue.destination as? ReceiptVendorDetailsViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedItemCell = sender as? VendorTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard tableView.indexPath(for: selectedItemCell) != nil else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                receiptVendorDetailsViewController.receipt = receipt
            
            case "ShowBillSplit":
                guard let billSplitTableViewController = segue.destination as? BillSplitTableViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                billSplitTableViewController.receipt = receipt;
            
        case "newItem":
            guard let nav = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let itemDetailsViewController = nav.viewControllers[0] as? NewItemViewController else {
                fatalError("Not a NewItemViewController)")
            }
            
            itemDetailsViewController.item = Item.init(name: "")
            
            default:
                fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }

}

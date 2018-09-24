//
//  BillSplitTableViewController.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/19/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class BillSplitTableViewController: UITableViewController {
    var receipt: Receipt!
    var sharers: [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (receipt != nil) {
            sharers = receipt.GetSharerIDs();
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Table view data source
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (sharers != nil) {
            if (receipt.GetUnaccountedCost() != Float(0)) {
                return sharers.count + 1
            }
            else {
                return sharers.count
            }
        }
        
        if (receipt.GetUnaccountedCost() != Float(0)) {
            return 1
        }
        else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "sharerCell", for: indexPath) as? ItemSharerTableViewCell {
            
            if (indexPath.row < sharers.count) {
                cell.profileImage.image = PersonManager.instance.GetPhoto(ID: sharers[indexPath.row])
                cell.sharerName.text    = PersonManager.instance.GetName(ID: sharers[indexPath.row])
                cell.sharerPrice.text   = receipt.GetSharerCostAsString(sharer: sharers[indexPath.row])
            }
            else {
                cell.profileImage.image = PersonManager.instance.GetVoidPhoto()
                cell.sharerName.text    = PersonManager.instance.GetVoidName()
                cell.sharerPrice.text   = receipt.GetUnaccountedCostAsString()
            }
            return cell;
        }

        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
        case "Breakdown":
            guard let billSplitBreakdownTableViewController = segue.destination as? BillSplitBreakdownTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedItemCell = sender as? ItemSharerTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            billSplitBreakdownTableViewController.receipt = receipt
            if (indexPath.row < sharers.count) {
                billSplitBreakdownTableViewController.sharer  = sharers[indexPath.row]
            }
            else {
                billSplitBreakdownTableViewController.sharer  = nil
            }
//            BillSplitBreakdownTableViewController.title = PersonManager.instance.GetName(ID: sharers[indexPath.row])
            
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
}

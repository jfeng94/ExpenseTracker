//
//  ItemTableViewController.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/18/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit
import os.log

class ItemTableViewController: UITableViewController {
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        tableView.reloadData()
//    }
    
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows = 3 // Details, sharer header, new sharer
        
        if (item != nil) {
            numRows += item.sharers.count
        }
        
        return numRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "itemDetailsCell", for: indexPath) as? ItemDetailsTableViewCell {
                cell.configure(item: item)
                return cell;
            }
        }
        else if (indexPath.row == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sharerHeaderCell", for: indexPath)
            return cell;
        }
        else if (indexPath.row > 1 && indexPath.row < item.sharers.count + 2) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "itemSharerCell", for: indexPath) as? ItemSharerTableViewCell {
                let sharer = item.sharers[indexPath.row - 2]
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 165
        }
        if (indexPath.row == 1) {
            return 25
        }
        if (indexPath.row == item.sharers.count + 2) {
            return 60
        }
        
        return 100
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.row <= 1) {
            return false
        }
        if (indexPath.row >= item.sharers.count + 2) {
            return false
        }
        return true
    }
 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            item.sharers.remove(at: indexPath.row - 2)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath.row > 1 && indexPath.row < item.sharers.count + 2) {
            return nil
        }
        return indexPath
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


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "EditItemDetails":
            guard let itemDetailsViewController = segue.destination as? ItemDetailsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard (sender as? ItemDetailsTableViewCell) != nil else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            itemDetailsViewController.item = item
            
        case "addNewSharer":
            guard let nextController = segue.destination as? PersonSelectionViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }

            nextController.excludedPeople = item.sharers
        
            
            
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
    
    func addSharer(ID: Int) {
        item.setSharerBuys(sharer: ID, numBought: 1)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

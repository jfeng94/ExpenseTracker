//
//  ReceiptHistoryTableViewController.swift
//  Cleaver
//
//  Created by Jerry Feng on 9/26/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class ReceiptHistoryTableViewController: UITableViewController {
    var receipts = [Receipt]()
    
    var cells = [Cell]()
    
    var newReceipt : Receipt!
    var returnFromNewReceipt = false
    
    struct Cell {
        enum Kind {
            case Receipt
            case NewReceipt
        }
        var kind = Cell.Kind.Receipt
        var receiptIdx = -1
        
        func getIdentifier() -> String {
            switch (self.kind) {
            case .Receipt:
                return "receiptCell"
                
            case .NewReceipt:
                return "newReceiptCell"
            }
        }
        
        func getHeight() -> CGFloat {
            switch (self.kind) {
            case .NewReceipt:
                return 60
                
            case .Receipt:
                return 60
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        if receipts.count == 0 {
            loadSampleReceipt()
        }
        
        repopulateCells()
        
        tableView.reloadData()
        
        tableView.setContentOffset(CGPoint.init(x: 0, y: cells[0].getHeight()), animated: false)
        
        if (returnFromNewReceipt) {
            returnFromNewReceipt = false
            performSegue(withIdentifier: "editNewReceipt", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Private Methods
    func repopulateCells() {

        cells.removeAll()
        
        var newReceipt = Cell()
        newReceipt.kind = .NewReceipt
        cells.append(newReceipt)
        
        receipts.sort(by: {$0.date > $1.date } )
        
        for i in 0..<receipts.count {
            var c = Cell()
            c.kind = .Receipt
            c.receiptIdx = i
            
            cells.append(c)
        }
        
    }
    
    func addReceipt(_ receipt : Receipt) {
        receipts.append(receipt)
        repopulateCells()
        tableView.reloadData()
    }
    
    func loadSampleReceipt() {
        let jerry = PersonManager.instance.CreateNewPerson()
        let grace = PersonManager.instance.CreateNewPerson()
        let tony  = PersonManager.instance.CreateNewPerson()
        let aris  = PersonManager.instance.CreateNewPerson()
        let tim   = PersonManager.instance.CreateNewPerson()
        
        PersonManager.instance.SetName(ID: jerry, name: "Jerry")
        PersonManager.instance.SetName(ID: grace, name: "Grace")
        PersonManager.instance.SetName(ID: tony,  name: "Tony")
        PersonManager.instance.SetName(ID: aris,  name: "Aris")
        PersonManager.instance.SetName(ID: tim,   name: "Tim")
        
        PersonManager.instance.SetPhoto(ID: jerry, photo: UIImage(named: "Jerry"))
        PersonManager.instance.SetPhoto(ID: grace, photo: UIImage(named: "Grace"))
        PersonManager.instance.SetPhoto(ID: tony,  photo: UIImage(named: "Tony"))
        PersonManager.instance.SetPhoto(ID: aris,  photo: UIImage(named: "Aris"))
        PersonManager.instance.SetPhoto(ID: tim,   photo: UIImage(named: "Tim"))
        
        let nngt1 = NSMutableDictionary(); nngt1[jerry] = 1; nngt1[aris] = 2
        let nngt2 = NSMutableDictionary(); nngt2[tony]  = 1;
        let rmt   = NSMutableDictionary();   rmt[grace] = 1;
        let pc1   = NSMutableDictionary();   pc1[jerry] = 1; pc1[grace] = 1
        let pc2   = NSMutableDictionary();   pc2[tim]   = 2;
        var items = [Item]()
        items += [Item.init(name: "Nom Nom Green Tea", note: "Boba, half sugar, no ice",       price: 4.45, tax: 9.25, tip: 0.0, sortingTag: "Drink",           sharers: [jerry, aris],  sharerBuys: nngt1)]
        items += [Item.init(name: "Nom Nom Green Tea", note: "Hal-f sugar, no ice, big straw", price: 3.95, tax: 9.25, tip: 0.0, sortingTag: "Drink",           sharers: [tony],         sharerBuys: nngt2)]
        items += [Item.init(name: "Rose Milk Tea",     note: "Bobes",                          price: 4.45, tax: 9.25, tip: 0.0, sortingTag: "Life sustenance", sharers: [grace],        sharerBuys: rmt)]
        items += [Item.init(name: "Popcorn Chicken",   note: "Mild",                           price: 4.95, tax: 9.25, tip: 0.0, sortingTag: "C H I C K E N",   sharers: [jerry, grace], sharerBuys: pc1)]
        items += [Item.init(name: "Popcorn Chicken",   note: "Spice me a new butthole",        price: 4.95, tax: 9.25, tip: 0.0, sortingTag: "C H I C K E N",   sharers: [tim],          sharerBuys: pc2)]
        
        let receipt = Receipt.init(vendorName: "Factory Tea Bar", items: items, date : Date.init())
        
        receipts += [receipt]
    }
    
    @IBAction func unwindToReceiptList(sender: UIStoryboardSegue) {
        if let src = sender.source as? NewReceiptViewController {
            newReceipt = src.receipt
            returnFromNewReceipt = true
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let c = cells[indexPath.row]
        switch (c.kind) {
        case Cell.Kind.Receipt:
            if let cell = tableView.dequeueReusableCell(withIdentifier: c.getIdentifier(), for: indexPath) as? ReceiptTableViewCell {
                
                let receipt = receipts[c.receiptIdx];
                cell.vendorName.text = receipt.vendorName
                cell.date.text       = Util.FormatDate(receipt.date)
                return cell;
            }
            
        case Cell.Kind.NewReceipt:
            return tableView.dequeueReusableCell(withIdentifier: c.getIdentifier(), for: indexPath);
        }
        
        return UITableViewCell()
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cells[indexPath.row].getHeight()
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch (segue.identifier ?? "") {
        case "showReceipt":
            if let dest = segue.destination as? ReceiptTableViewController {
                if let cell = sender as? ReceiptTableViewCell {
                    if let idx = tableView.indexPath(for: cell) {
                        dest.receipt = receipts[cells[idx.row].receiptIdx]
                    }
                }
            }
            
        case "newReceipt":
            if let dest = segue.destination as? UINavigationController {
                if let next = dest.viewControllers[0] as? NewReceiptViewController {
                    next.controller = self
                }
            }
            
        case "editNewReceipt":
            print("edit new receipt")
            if let dest = segue.destination as? ReceiptTableViewController {
                    dest.receipt = newReceipt
            }
            
        default:
            fatalError("Unexpected segue? \(segue.identifier)")
        }
        

        
        
    }

}

//
//  ItemDetailsViewController.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/21/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class NewItemViewController: UITableViewController {
    
    struct Cell {
        enum Kind {
            case Details
            case Header
            case Sharer
            case AddNewSharer
        }
        var kind = Cell.Kind.Details
        var sharersIdx = -1
        
        func getIdentifier() -> String {
            switch (self.kind) {
            case .Details:
                return "detailsCell"
            case .Header:
                return "headerCell"
            case .Sharer:
                return "sharerCell"
            case .AddNewSharer:
                return "newSharerCell"
            }
        }
        
        func getHeight() -> CGFloat {
            switch (self.kind) {
            case .Details:
                return 268
            case .Header:
                return 25
            case .Sharer:
                return 90
            case .AddNewSharer:
                return 60
            }
        }
    }
    
    var cells = [Cell]()
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var item: Item!
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: ViewController Methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (saveButton != nil) {
            saveButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cells.removeAll()
        
        var details = Cell()
        details.kind = .Details
        cells.append(details)
        
        var header = Cell()
        header.kind = .Header
        cells.append(header)
        
        if (item.sharers.count > 0) {
            for i in 0...item.sharers.count - 1 {
                var sharerCell = Cell()
                sharerCell.kind = .Sharer
                sharerCell.sharersIdx = i
                
                cells.append(sharerCell)
            }
        }
        
        var newSharer = Cell()
        newSharer.kind = .AddNewSharer
        cells.append(newSharer)
        
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Actions
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func cancel(_ sender: UIBarButtonItem) {
//        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Table View Delegate Methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = cells[indexPath.row]
        switch (c.kind) {
        case Cell.Kind.Sharer:
            if let cell = tableView.dequeueReusableCell(withIdentifier: c.getIdentifier(), for: indexPath) as? NewItemSharerViewCell {
                let sharer = item.sharers[c.sharersIdx]
                cell.configure(sharerID: sharer, item: item, controller: self)
                return cell;
            }
            
        case Cell.Kind.Details:
            if let cell = tableView.dequeueReusableCell(withIdentifier: c.getIdentifier(), for: indexPath) as? NewItemDetailsTableViewCell {
                cell.configure(item: item, controller: self)
                return cell;
            }
            
        
        default:
            return tableView.dequeueReusableCell(withIdentifier: c.getIdentifier(), for: indexPath)
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cells[indexPath.row].getHeight()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch (cells[indexPath.row].kind) {
        case Cell.Kind.Sharer:
            return true
        
        default:
            return false
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let c = cells[indexPath.row]
            if c.kind == .Sharer {
                // Delete the row from the data source
                item.sharers.remove(at: c.sharersIdx)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        view.endEditing(true)
        
        switch (cells[indexPath.row].kind) {
        case .AddNewSharer:
            return indexPath
            
        default:
            return nil
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Private methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func updateSaveButtonState() {
        if (saveButton != nil) {
            saveButton.isEnabled = (!item.name .isEmpty && item.sharers.count != 0)
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Navigation
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "addNewSharer":
            guard let nextController = segue.destination as? PersonSelectionViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            nextController.excludedPeople = item.sharers
        
        case "itemSaved":
            // Do nothing
            print("Item saved!")
            
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier)) from \(String(describing: sender.debugDescription))")
        }
    }
    
    func addSharer(ID: Int) {
        item.setSharerBuys(sharer: ID, numBought: 1)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

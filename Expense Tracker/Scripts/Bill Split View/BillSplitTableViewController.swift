//
//  BillSplitTableViewController.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/19/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class BillSplitTableViewController: UITableViewController {
    struct Cell {
        enum Kind {
            case Info
            case Sharer
            case Blank
        }
        var kind = Cell.Kind.Info
        var sharersIdx = -1
        
        func getIdentifier() -> String {
            switch (self.kind) {
            case .Info:
                return "infoCell"
            case .Sharer:
                return "sharerCell"
            case .Blank:
                return "default"
            }
        }
        
        func getHeight() -> CGFloat {
            switch (self.kind) {
            case .Blank:
                return 80
                
            case .Info:
                return 80
                
            case .Sharer:
                return 60
            }
        }
    }
    
    var cells = [Cell]()
    
    var receipt: Receipt!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let screenshotItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.camera, target: self, action: #selector(self.screenshot));
        self.navigationItem.rightBarButtonItem = screenshotItem
        
        repopulateCells()
        tableView.reloadData()
    }
    
    func repopulateCells() {
        cells.removeAll()
        
        cells.append(Cell())
        
        if (receipt != nil) {
            var sharers = receipt.GetSharerIDs();
            
            // Sort by alphabetical order
            sharers.sort(by: {PersonManager.instance.GetName(ID: $0) < PersonManager.instance.GetName(ID: $1)} )
            
            for i in 0..<sharers.count {
                var c = Cell()
                c.kind = .Sharer
                c.sharersIdx = sharers[i]
                cells.append(c)
            }
        }
    }
    
    @objc func screenshot() {
        
        var image = UIImage();
        UIGraphicsBeginImageContextWithOptions(self.tableView.contentSize, false, UIScreen.main.scale)
        
        // save initial values
        let savedContentOffset = self.tableView.contentOffset;
        let savedFrame = self.tableView.frame;
        let savedBackgroundColor = self.tableView.backgroundColor
        
        var contentHeight = CGFloat(0)
        for cell in cells {
            contentHeight = contentHeight + cell.getHeight()
        }
        
        // reset offset to top left point
        self.tableView.contentOffset = CGPoint(x: 0, y: 0);
        // set frame to content size
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.tableView.contentSize.width, height: contentHeight);
        // remove background
        self.tableView.backgroundColor = UIColor.clear
        
        // make temp view with scroll view content size
        // a workaround for issue when image on ipad was drawn incorrectly
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.contentSize.width, height: contentHeight));
        
        // save superview
        let tempSuperView = self.tableView.superview
        // remove scrollView from old superview
        self.tableView.removeFromSuperview()
        // and add to tempView
        tempView.addSubview(self.tableView)
        
        // render view
        // drawViewHierarchyInRect not working correctly
        tempView.layer.render(in: UIGraphicsGetCurrentContext()!)
        // and get image
        image = UIGraphicsGetImageFromCurrentImageContext()!;
        
        // and return everything back
        tempView.subviews[0].removeFromSuperview()
        tempSuperView?.addSubview(self.tableView)
        
        // restore saved settings
        self.tableView.contentOffset = savedContentOffset;
        self.tableView.frame = savedFrame;
        self.tableView.backgroundColor = savedBackgroundColor
        
        UIGraphicsEndImageContext();
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        let alertController = UIAlertController(title: "Screenshot Saved", message:
            "An image of your bill split has been saved to your camera roll!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
        return cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = cells[indexPath.row]
        switch (c.kind) {
        case Cell.Kind.Sharer:
            if let cell = tableView.dequeueReusableCell(withIdentifier: c.getIdentifier(), for: indexPath) as? ItemSharerTableViewCell {
                
                let ID = c.sharersIdx;
                                cell.profileImage.image = PersonManager.instance.GetPhoto(ID: ID)
                cell.sharerName.text    = PersonManager.instance.GetName(ID: ID)
                cell.sharerPrice.text   = receipt.GetSharerCostAsString(sharer: ID)
                return cell;
            }
            
        case Cell.Kind.Info:
            if let cell = tableView.dequeueReusableCell(withIdentifier: c.getIdentifier(), for: indexPath) as? ReceiptInfoTableViewCell {
                cell.name.text = receipt.vendorName
                cell.date.text = Util.FormatDate(receipt.date)
                return cell;
            }
            
        default:
            return UITableViewCell()
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
            billSplitBreakdownTableViewController.sharer = cells[indexPath.row].sharersIdx
            
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
}

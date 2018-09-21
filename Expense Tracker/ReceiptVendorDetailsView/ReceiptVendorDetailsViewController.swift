//
//  ReceiptVendorDetailsViewController.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/20/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class ReceiptVendorDetailsViewController: UIViewController {
    var receipt: Receipt!
    @IBOutlet weak var vendorName: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var tax: UITextField!
    @IBOutlet weak var tip: UITextField!
    
    private var datePicker : UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime;
        datePicker.addTarget(self, action: #selector(ReceiptVendorDetailsViewController.dateChanged(datePicker:)), for: .valueChanged)
        date.inputView = datePicker
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ReceiptVendorDetailsViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true);
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY hh:mm a"
        date.text = dateFormatter.string(from: datePicker.date)
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

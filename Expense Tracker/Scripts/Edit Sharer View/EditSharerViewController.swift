//
//  EditSharerViewController.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/24/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class EditSharerViewController: UIViewController {
    var isNewSharer = true
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let title : String
        if isNewSharer {
            
//            let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
//            let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: height, width: 320, height: 44))
//
//            self.view.addSubview(navBar);

            let navItem = UINavigationItem(title: "New Sharer");
            let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(self.cancel(_:)));
            navItem.leftBarButtonItem = cancelItem;
            
            navBar.setItems([navItem], animated: false);
            navBar.isHidden = false

        }
        else {
            title = "Edit sharer"
            self.navigationItem.title = title
            
            navBar.removeFromSuperview()
            navBar.isHidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions
    @objc func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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

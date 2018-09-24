//
//  PersonTableViewCell.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/23/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var ID = PersonManager.voidPersonID
    
    func setPerson(ID : Int) {
        photo.image = PersonManager.instance.GetPhoto(ID: ID)
        name.text   = PersonManager.instance.GetName(ID: ID)
        
        self.ID = ID
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

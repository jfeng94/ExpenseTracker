//
//  Person.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/18/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit

class Person {
    //MARK: Properties
    var ID: String      // UUID for person
    var name: String    // Name of person
    var photo: UIImage? // Profile picture
    
    // Create a person, manually setting the UUID
    init(ID: String, name: String, photo: UIImage?) {
        self.ID = ID
        self.name = name
        self.photo = photo
    }
    
    // Create a person, letting the application generate the UUID. This initializer is failable.
    init?(name: String, photo: UIImage?) {
        if name.isEmpty {
            return nil;
        }
        
        self.ID = NSUUID().uuidString
        self.name = name
        self.photo = photo
    }
    
    func GetID() -> String {
        return ID
    }
}

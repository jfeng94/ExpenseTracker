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
    private var ID: String      // UUID for person
    private var name: String    // Name of person
    private var photo: UIImage? // Profile picture
    
    // Create a person, manually setting the UUID
    init(manager: PersonManager, ID: String, name: String, photo: UIImage?) {
        self.ID = ID
        self.name = name
        self.photo = photo
    }
    
    init() {
        self.ID = NSUUID().uuidString
        self.name = ""
        self.photo = nil
    }
    
    func GetID() -> String {
        return ID
    }
    
    func GetPhoto() -> UIImage? {
        return photo
    }
    
    func GetName() -> String {
        return name
    }
    
    func SetPhoto(manager: PersonManager, photo: UIImage?) {
        self.photo = photo
    }
    
    func SetName(manager: PersonManager, name: String) {
        self.name = name;
    }
}

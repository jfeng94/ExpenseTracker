//
//  PersonBank.swift
//  Expense Tracker
//
//  Created by Jerry Feng on 9/21/18.
//  Copyright © 2018 Jerry Feng. All rights reserved.
//

import UIKit
import os.log

class PersonManager {
    private var idToPerson : NSMutableDictionary
    
    static let instance = PersonManager()
    
    private init() {
        self.idToPerson = NSMutableDictionary()
    }
    
    private func GetPerson(ID: String) -> Person? {
        let person = idToPerson[ID] as? Person
        
        if (person == nil) {
            os_log("No such person: %s", ID)
        }
        
        return person
    }
    
    private func AddPerson(person: Person) {
        idToPerson[person.GetID()] = person
    }
    
    func CreateNewPerson() -> String {
        let newPerson = Person.init()
        AddPerson(person: newPerson)
        return newPerson.GetID()
    }

    func GetPhoto(ID: String) -> UIImage? {
        let person = GetPerson(ID: ID)
        if (person != nil) {
            return person?.GetPhoto()
        }
        
        return nil
    }

    func GetVoidPhoto() -> UIImage? {
        return UIImage(named: "Void User")
    }
    
    func GetName(ID: String) -> String {
        let person = GetPerson(ID: ID)
        if (person != nil) {
            return person!.GetName()
        }
        
        return ""
    }
    
    func GetVoidName() -> String {
        return "Lost to the void..."
    }
    
    func SetPhoto(ID: String, photo: UIImage?) {
        let person = GetPerson(ID: ID)
        
        if (person != nil) {
            person!.SetPhoto(manager: self, photo: photo)
        }
    }
    
    func SetName(ID: String, name: String) {
        let person = GetPerson(ID: ID)
        
        if (person != nil) {
            person!.SetName(manager: self, name: name)
        }
    }
}

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
    
    static var currID = 0
    static var voidPersonID = -1
    
    private init() {
        self.idToPerson = NSMutableDictionary()
    }
    
    private func GetPerson(ID: Int) -> Person? {
        let person = idToPerson[ID] as? Person
        
        if (person == nil) {
            os_log("No such person: %s", ID)
        }
        
        return person
    }
    
    private func AddPerson(person: Person) {
        idToPerson[person.GetID()] = person
    }

    private func CreateVoidPerson() {
        let newPerson = Person.init(manager: self, ID: PersonManager.voidPersonID)
        SetName(ID: PersonManager.voidPersonID, name: "Unaccounted")
        SetPhoto(ID: PersonManager.voidPersonID, photo: GetVoidPhoto())
        AddPerson(person: newPerson)
    }
    
    func GetVoidPhoto() -> UIImage? {
        return UIImage(named: "Void User")
    }
    
    func GetVoidName() -> String {
        return "Unaccounted"
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: PUBLIC INTERFACE
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func CreateNewPerson() -> Int {
        let newPerson = Person.init(manager: self, ID: PersonManager.currID)
        PersonManager.currID = PersonManager.currID + 1
        AddPerson(person: newPerson)
        return newPerson.GetID()
    }

    func GetPhoto(ID: Int) -> UIImage? {
        if (ID == PersonManager.voidPersonID) {
            return GetVoidPhoto()
        }
        
        let person = GetPerson(ID: ID)
        if (person != nil) {
            return person?.GetPhoto()
        }
        
        return nil
    }

    
    func GetName(ID: Int) -> String {
        if (ID == PersonManager.voidPersonID) {
            return GetVoidName()
        }
        
        let person = GetPerson(ID: ID)
        if (person != nil) {
            return person!.GetName()
        }
        
        return ""
    }
    
    func SetPhoto(ID: Int, photo: UIImage?) {
        let person = GetPerson(ID: ID)
        
        if (person != nil) {
            person!.SetPhoto(manager: self, photo: photo)
        }
    }
    
    func SetName(ID: Int, name: String) {
        let person = GetPerson(ID: ID)
        
        if (person != nil) {
            person!.SetName(manager: self, name: name)
        }
    }
    
    func GetPeople(excluding: [Int]) -> [Int] {
        var toReturn = [Int]()
        let keys = idToPerson.allKeys
        for key in keys {
            if let id = key as? Int {
                var add = true
                for excluded in excluding {
                    if (id == excluded || id == PersonManager.voidPersonID) {
                        add = false
                        break
                    }
                }
                if (add) {
                    toReturn += [id]
                }
            }
        }
        
        // Sort by alphabetical order
        toReturn.sort(by: {GetName(ID: $0) < GetName(ID: $1)} )
        
        return toReturn
    }
}

//
//  Character.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 10/31/19.
//  Copyright © 2019 Tryal by Fyre. All rights reserved.
//

import UIKit

class Character: NSObject {
     
    static let shared = Character()
    
    var model = CharacterModel()
    var name:String {
        set {
            model.name = newValue
        }
        get {
            return model.name
        }
    }
    var race:String {
        set {
            model.race = newValue
        }
        get {
            return model.race
        }
    }
    
    var level:String {
        set {
            model.level = Int(newValue) ?? 1
        }
        get {
            return "\(model.level)"
        }
    }
    var currentHP:String {
        set {
            model.currentHP = Int(newValue) ?? 0
        }
        get {
            return "\(model.currentHP)"
        }
    }
    
    var str:String {
        set {
            model.str = Int(newValue) ?? 0
        }
        get {
            return "\(model.str)"
        }
    }
    var int:String {
        set {
            model.int = Int(newValue) ?? 0
        }
        get {
            return "\(model.int)"
        }
    }
    
    var dex:String {
        set {
            model.dex = Int(newValue) ?? 0
        }
        get {
            return "\(model.dex)"
        }
    }
    var con:String {
        set {
            model.con = Int(newValue) ?? 0
        }
        get {
            return "\(model.con)"
        }
    }
    var wis:String {
        set {
            model.wis = Int(newValue) ?? 0
        }
        get {
            return "\(model.wis)"
        }
    }
    var cha:String {
        set {
            model.cha = Int(newValue) ?? 0
        }
        get {
            return "\(model.cha)"
        }
    }
    
}

struct CharacterModel: Codable {
    var name = ""
    var race = ""
    var currentHP = 0
    var level = Int(1)
    var str = Int(1)
    var int = Int(1)
    var dex = Int(1)
    var wis = Int(1)
    var con = Int(1)
    var cha = Int(1)

}

//
//  Character.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 10/31/19.
//  Copyright © 2019 Tryal by Fyre. All rights reserved.
//

import UIKit

class Character: ObservableObject {
     
    static let shared = Character()
    
    @Published var model = CharacterModel()
    var name:String {
        set {
            model.name = newValue
        }
        get {
            return model.name
        }
    }
    var race = Race()
    var alignment:String {
           set {
               model.alignment = newValue
           }
           get {
               return model.alignment
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
    var speed:String {
        set {
            model.speed = Int(newValue) ?? 1
        }
        get {
            return "\(model.speed)"
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
    var armorClass:String {
        set {
            model.armorClass = Int(newValue) ?? 0
        }
        get {
            return "\(model.armorClass)"
        }
    }
    
    var str:String
    {
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
    
    var actions:[Action] { return model.actions }
    
    var strMod:String { return "\(Int((model.str - 10)/2))"}
    var dexMod:String { return "\(Int((model.dex - 10)/2))"}
    var conMod:String { return "\(Int((model.con - 10)/2))"}
    var intMod:String { return "\(Int((model.int - 10)/2))"}
    var wisMod:String { return "\(Int((model.wis - 10)/2))"}
    var chaMod:String { return "\(Int((model.cha - 10)/2))"}

}

struct CharacterModel: Codable {
    var name = ""
    var raceModel:RaceModel?
    var subrace:RaceModel?
    var alignment = ""
    var currentHP = 0
    var armorClass = 0
    var speed = 30
    var level = Int(1)
    var str = Int(1)
    var int = Int(1)
    var dex = Int(1)
    var wis = Int(1)
    var con = Int(1)
    var cha = Int(1)

    var actions = [Action]()
}

struct Action: Codable, Identifiable {
    var id = UUID()
    var name = ""
    var desc = ""
}

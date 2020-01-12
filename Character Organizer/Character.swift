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
    var race:Race = Race() {
        didSet {
            self.speed = "\(self.race.speed)"
            self.languages.formUnion(self.race.selectedLanguages)
        }
    }
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
    
    var charcaterClass = CharacterClass.sharedClasses[0]
    
    var actions:[Action] { return model.actions }
    
    var strMod:String { return modString(model.str) }
    var dexMod:String { return modString(model.dex) }
    var conMod:String { return modString(model.con) }
    var intMod:String { return modString(model.int) }
    var wisMod:String { return modString(model.wis) }
    var chaMod:String { return modString(model.cha) }
    
    func modString(_ attribute:Int) -> String {
        
        let result = Int((attribute - 10)/2)
        if result > 0 {
            return "+\(result)"
        }
        return "\(result)"
        
    }
    
    var languages = Set<Descriptor>()

}

struct CharacterModel: Codable {
    var name = ""
    var raceModel:RaceModel?
    var subrace:RaceModel?
    var characterClass:ClassModel?
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

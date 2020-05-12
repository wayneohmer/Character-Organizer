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
    
    static let aligment1 = ["Lawful","Neutral","Chaotic"]
    static let aligment2 = ["Good","Neutral","Evil"]
    
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
            self.languages.removeAll()
            self.languages.formUnion(self.race.selectedLanguages)
            self.languages.formUnion(self.race.languages ?? [Descriptor]())
            self.proficiencies.removeAll()
            for descriptor in race.startingProficiencies ?? [Descriptor]() {
                if let prof = Proficiency.shared[descriptor.url] {
                    if let skill = prof.skill  {
                        self.skills.insert(skill)
                    } else {
                        self.proficiencies.insert(prof)
                    }
                }
            }
            self.traits.removeAll()
            for descriptor in race.traits ?? [Descriptor]() {
                if let trait = Trait.shared[descriptor.url] {
                    self.traits.insert(trait)
                }
            }
        }
    }
    
    var charcaterClass = CharacterClass() {
        didSet {
            self.proficiencies.formUnion(self.charcaterClass.proficiencies)
            for prof in self.charcaterClass.selectedProficiencies {
                if let skill = prof.skill {
                    self.skills.insert(skill)
                } else {
                    self.proficiencies.insert(prof)
                }
            }
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
    
    var maxHP:String {
        set {
            model.maxHP = Int(newValue) ?? 0
        }
        get {
            return "\(model.maxHP)"
        }
    }
    
    var tempHP:String {
        set {
            model.tempHP = Int(newValue) ?? 0
        }
        get {
            return "\(model.tempHP)"
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
    var languageString:String {
        let langs = languages.map({ $0.name })
        return langs.joined(separator: ", ")
    }
    var proficiencies = Set<Proficiency>()
    var skills = Set<Skill>()
    var traits = Set<Trait>()
    var alingment1Idx:Int { return model.alingment1Idx }
    var alingment2Idx:Int { return model.alingment2Idx }
    var alingment:String {
        if self.alingment1Idx == 1, alingment2Idx == 1 {
            return "Neutral"
        } else {
            return "\(Character.aligment1[alingment1Idx]) \(Character.aligment2[alingment2Idx])"
        }
    }
    var equipment:[Equipment] { return model.equipment }
    var spells:[Spell] { return model.spells }
    var weapons:[Equipment] { return self.equipment.filter({$0.equipment_category == "Weapon"}).sorted() }
    var armor:[Equipment] { return self.equipment.filter({$0.equipment_category == "Armor"}).sorted() }

}

struct CharacterModel: Codable {
    var name = ""
    var raceModel:RaceModel?
    var subrace:RaceModel?
    var characterClass:ClassModel?
    var alignment = ""
    var currentHP = 0
    var maxHP = 0
    var tempHP = 0
    var armorClass = 0
    var speed = 30
    var level = Int(1)
    var str = Int(1)
    var int = Int(1)
    var dex = Int(1)
    var wis = Int(1)
    var con = Int(1)
    var cha = Int(1)
    var alingment1Idx:Int = 1
    var alingment2Idx:Int = 1

    var actions = [Action]()
    var equipment = [Equipment]()
    var spells = [Spell]()
}

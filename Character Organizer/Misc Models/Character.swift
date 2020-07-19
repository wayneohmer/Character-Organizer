//
//  Character.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 10/31/19.
//  Copyright © 2019 Tryal by Fyre. All rights reserved.
//

import UIKit

enum Attribute: String, CaseIterable {
    
    case STR
    case DEX
    case CON
    case INT
    case WIS
    case CHA
    
    func desc() -> String {
        switch self {
        case .STR:
            return "Strength"
        case .DEX:
            return "Dexterity"
        case .CON:
            return "Constution"
        case .INT:
            return "Intelligence"
        case .WIS:
            return "Wisdom"
        case .CHA:
            return "Charisma"
        }
    }
    func idx() -> Int {
           switch self {
           case .STR:
               return 0
           case .DEX:
               return 1
           case .CON:
               return 2
           case .INT:
               return 3
           case .WIS:
               return 4
           case .CHA:
               return 5
           }
       }
}

class CharacterSet: ObservableObject {
    
    static var shared = CharacterSet()
    
    @Published var allCharacters = Set<CharacterModel>()

}

class Character: ObservableObject {
    
    static var shared = Character()
    
    static let aligment1 = ["Lawful","Neutral","Chaotic"]
    static let aligment2 = ["Good","Neutral","Evil"]
    static let AttributeDict = ["STR":"Strength","DEX":"Dexterity","CON":"Constution","INT":"Intelligence","WIS":"Wisdom","CHA":"Charisma"]
    static let AttributeArray = ["Strength","Dexterity","Constution","Intelligence","Wisdom","Charisma"]

    @Published var model = CharacterModel()
    
    var name:String {
        set {
            model.name = newValue
        }
        get {
            return model.name
        }
    }
    var race:Race {
        
        set {
            self.model.raceModel = newValue.model
            self.speed = "\(self.race.speed)"
            self.languages.removeAll()
            self.languages.formUnion(self.race.selectedLanguages)
            self.languages.formUnion(self.race.languages ?? [Descriptor]())
            self.model.proficiencies.removeAll()
            for descriptor in race.startingProficiencies ?? [Descriptor]() {
                if let prof = Proficiency.shared[descriptor.url] {
                    if let skill = prof.skill  {
                        self.model.skills.insert(skill)
                    } else {
                        self.model.proficiencies.insert(prof)
                    }
                }
            }
            self.model.traits.removeAll()
            for descriptor in race.traits ?? [Descriptor]() {
                if let trait = Trait.shared[descriptor.url] {
                    self.model.traits.insert(trait)
                }
            }
        }
        get {
            Race(model: model.raceModel ?? Race.shared[0].model )
        }
        
    }
    
    var charcaterClass:CharacterClass {
        set {
            self.model.characterClass = newValue.model
            self.model.proficiencies.formUnion(self.charcaterClass.proficiencies)
            for prof in self.charcaterClass.selectedProficiencies {
                if let skill = prof.skill {
                    self.model.skills.insert(skill)
                } else {
                    self.model.proficiencies.insert(prof)
                }
            }
        }
        get {
            return CharacterClass(model: self.model.characterClass ?? CharacterClass.shared[0].model)
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
            if model.currentHP > model.maxHP {
                model.currentHP = model.maxHP
            }
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
    
    var effectiveHP:String {
           set {
               model.tempHP = Int(newValue) ?? 0
           }
           get {
            return "\(model.currentHP + model.tempHP)"
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
    var proficiencyBonus:String {
        set {
            model.proficiencyBonus = Int(newValue) ?? 0
        }
        get {
            return "\(model.proficiencyBonus)"
        }
    }
    
    var casterAttributeIdx:Int? {
        set {
            model.casterAttributeIdx = newValue
        }
        get {
            return model.casterAttributeIdx
        }
    }
    
    var image: UIImage {
        set {
            self.model.imageData =  newValue.jpegData(compressionQuality: 0)
        }
        get {
            if let image = UIImage(data: self.model.imageData ?? Data()) {
                return image
            }
            return UIImage(named: "Wayne")!
        }
    }
        
    var attrDict:[Attribute: Int] { return [.STR:model.str, .DEX:model.dex, .CON:model.con, .INT:model.int, .WIS:model.wis, .CHA:model.cha] }
    var attrArray:[Int] { return [model.str, model.dex, model.con, model.int, model.wis, model.cha] }
    var attrBonusDict:[Attribute: Int] { return [.STR:modValue(model.str),.DEX:modValue(model.dex),.CON:modValue(model.con),.INT:modValue(model.int),.WIS:modValue(model.wis),.CHA:modValue(model.cha)] }
    var attrBonusArray:[Int] { return [modValue(model.str),modValue(model.dex),modValue(model.con),modValue(model.int),modValue(model.wis),modValue(model.cha)] }

    var actions:Set<Action> { return model.actions }
    
    var attackActions:[Action] { return model.actions.filter({ $0.isAttack }) }
    var weaponAttacks:[Action] { return attackActions.filter({ $0.weapon != nil }) }
    var spellAttacks:[Action] { return attackActions.filter({ $0.spell != nil }) }
    var otherAttacks:[Action] { return attackActions.filter({ $0.spell == nil && $0.weapon == nil }) }

    var strMod:String { return modString(model.str) }
    var dexMod:String { return modString(model.dex) }
    var conMod:String { return modString(model.con) }
    var intMod:String { return modString(model.int) }
    var wisMod:String { return modString(model.wis) }
    var chaMod:String { return modString(model.cha) }
        
    var languages = Set<Descriptor>()
    var languageString:String {
        let langs = languages.map({ $0.name })
        return langs.joined(separator: ", ")
    }
    var proficiencies: Set<Proficiency> { return model.proficiencies }
    var skills: Set<Skill> { return model.skills }
    var traits: Set<Trait> { return model.traits }
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
    var spellActions:[Action] { return model.actions.filter({ $0.spell != nil }) }
    var miscActions:[Action] { return model.actions.filter({ $0.spell == nil && $0.weapon == nil }) }
    var weapons:[Equipment] { return self.equipment.filter({$0.equipment_category == "Weapon"}).sorted() }
    var armor:[Equipment] { return self.equipment.filter({$0.equipment_category == "Armor"}).sorted() }
    
    var spellDC: Int {
        return 8 + (self.attrBonusArray[model.casterAttributeIdx ?? 3]) + self.model.proficiencyBonus
    }
    
    convenience init(model: CharacterModel) {
        self.init()
        self.model = model
        self.race = Race(model: model.raceModel ?? RaceModel())
        self.charcaterClass = CharacterClass(model: model.characterClass ?? ClassModel())
    }
    
    func modValue (_ attribute:Int) -> Int {
        return Int((attribute - 10)/2)
    }
    
    func modString(_ attribute:Int) -> String {
        
        let result = Int((attribute - 10)/2)
        if result > 0 {
            return "+\(result)"
        }
        return "\(result)"
        
    }
    
    func saveModFor(attr: Attribute) -> Int {
        return self.model.proficientSaves.contains(attr.idx()) ? (self.attrBonusDict[attr] ?? 0) + self.model.proficiencyBonus : (self.attrBonusDict[attr] ?? 0)
    }
    
    func saveProfModFor(attr: Attribute) -> Int {
        return self.model.proficientSaves.contains(attr.idx()) ? self.model.proficiencyBonus : 0
    }
    
    
    func addSpellAction(_ spell: Spell) {
        var action = Action()
        action.spell = spell
        action.name = spell.name
        action.isAttack = spell.isAttack
        action.attrIndex = self.casterAttributeIdx ?? 0
        action.timingIndex = ActionTiming.allCases.firstIndex(of: spell.timeing ?? .Long) ?? 0
        action.damageType = spell.damageType
        action.damageTypeIndex = DamageType.shared.map({$0.value.name}).sorted().firstIndex(of: spell.damageType) ?? 0

        if let dice = spell.likelyDice {
            action.damageDice = dice.model
        }
        self.model.actions.insert(action)
    }
    
    class func create() -> Character {
        let new = Character()
        
        new.charcaterClass = CharacterClass.shared[0]
        new.name = "Name"
        new.race = Race.shared[0]
        for descriptor in new.race.startingProficiencies ?? [Descriptor]() {
            if let prof = Proficiency.shared[descriptor.url] {
                new.model.proficiencies.insert(prof)
            }
        }
        new.model.proficiencies.formUnion(Set(new.charcaterClass.proficiencies))
        new.level = "1"
        new.armorClass = "10"
        new.speed = "10"
        new.maxHP = "35"
        new.currentHP = "35"
        new.tempHP = "0"
        new.str = "9"
        new.dex = "9"
        new.con = "9"
        new.int = "9"
        new.wis = "9"
        new.cha = "9"
        new.casterAttributeIdx = 0
        new.proficiencyBonus = "2"
        new.model.actions = Set<Action>()
        new.model.isActive = true
        for spell in new.model.spells {
            new.addSpellAction(spell)
        }
        return new
    }

}

struct CharacterModel: Codable, Comparable, Hashable  {
    
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
    var proficiencyBonus = Int(1)
    var alingment1Idx:Int = 1
    var alingment2Idx:Int = 1
    var casterAttributeIdx: Int?
    var isActive = false
    var isSpellCaster = true
    var imageData: Data?

    var proficiencies = Set<Proficiency>()
    var proficientSaves = Set<Int>()
    var skills = Set<Skill>()
    var traits = Set<Trait>()
    var actions = Set<Action>()
    var equipment = [Equipment]()
    var spells = [Spell]()
    var spellSlots:[Int:Int] = [1:0,2:0,3:0,4:0,5:0,6:0,7:0,8:0,9:0]
    var spellSlotsUsed:[Int:Int] = [1:0,2:0,3:0,4:0,5:0,6:0,7:0,8:0,9:0]

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: CharacterModel, rhs: CharacterModel) -> Bool {
        lhs.name == rhs.name
    }
    
    static func < (lhs: CharacterModel, rhs: CharacterModel) -> Bool {
        lhs.name < rhs.name
    }
    
    
}

//
//  Action.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 3/22/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

enum ActionTiming: String, CaseIterable {
    case Action
    case BonusAction = "Bonus Action"
    case Reaction
    case Move
    case Long
    case All
}

struct Action: Codable, Identifiable, Comparable, Hashable, Viewable {
    
    var id:String { return name }
    var name: String = ""
    var desc: String = ""
    var attack_bonus: Int = 0
    var damage_dice: String?
    var damage_bonus: Int = 0
    var damageType: String?
    var damageTypeIndex: Int = 0
    var isProficient = true
    var attrDamage = false
    var attrIndex = 0
    var isAttack = false
    var timingIndex: Int = 0
    var isMisc:Bool { return spell == nil && weapon == nil }
    var damageDice: FyreDiceModel = FyreDiceModel()
    var isMagicItem: Bool? = false
    var spell: Spell?
    var weapon: Equipment?
    var description: String {
        if let weapon = weapon {
            return weapon.description
        } else if let spell = spell {
            return spell.description
        }
        return desc
    }
    
    var timing:ActionTiming { return ActionTiming.allCases[timingIndex] }
    
    var damageFyreDice:FyreDice {
        return FyreDice(with: damageDice.dice, modifier: damageDice.modifier)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func < (lhs: Action, rhs: Action) -> Bool {
        if lhs.isMisc && !rhs.isMisc {
            return true
        } else if !lhs.isMisc && rhs.isMisc {
            return false
        } else if lhs.weapon != nil && rhs.spell != nil {
            return true
        } else if lhs.spell != nil && rhs.weapon != nil {
            return false
        } else if let lhsSpell = lhs.spell, let  rhsSpell = rhs.spell {
            if lhsSpell.level == rhsSpell.level {
                return lhsSpell.name < rhsSpell.name
            } else {
                return lhsSpell.level > rhsSpell.level
            }
        } else {
            return lhs.name < rhs.name
        }
    }
    
    static func fromWeapon (weapon: Equipment) -> Action {
        
        var action = Action()
        
        action.weapon = weapon
        action.name = weapon.name
        if weapon.weapon_range == "Melee" {
            action.attrIndex = 0
        } else if weapon.weapon_range == "Ranged" {
            action.attrIndex = 1
        }
        action.damageDice = weapon.damageDice().model
        action.damageType = weapon.damage?.damage_type?.name
        action.isProficient = true
        action.attrDamage = true
        action.isAttack = true
        action.timingIndex = 0
        action.damageTypeIndex = DamageType.shared.map({$0.value.name}).sorted().firstIndex(of: weapon.damage?.damage_type?.name ?? "") ?? 0

        return action
    }
    
    mutating func getPastedString() {
        
        guard let pastedString = UIPasteboard.general.string, pastedString != "" else {
            return
        }
        var firstLine = ""
        let regex = try! NSRegularExpression(pattern: "(.*)(\\r|\\n)")
        let range = NSRange(location: 0, length: pastedString.count)
        let matches = regex.matches(in: pastedString, range: range)
        if matches.count > 0 {
            firstLine = matches.map {
                String(pastedString[Range($0.range, in: pastedString)!])
                }[0]
            self.name = firstLine.capitalized
            self.desc = String(pastedString.dropFirst(firstLine.count))
        }
        
    }
    
}

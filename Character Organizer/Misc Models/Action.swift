//
//  Action.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 3/22/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import Foundation

enum ActionTiming: String, CaseIterable {
    case Action
    case BonusAction = "Bonus Action"
    case Reaction
    case Move
    case Long
    case All
}

struct Action: Codable, Identifiable, Comparable, Hashable, Viewable {
    
    var id = UUID()
    var name: String = ""
    var desc: String = ""
    var attack_bonus: Int = 0
    var damage_dice: String?
    var damage_bonus: Int = 0
    var damageType: String?
    var damageTypeIndex: Int = 0
    var isProficient = false
    var attrDamage = false
    var attrIndex = 0
    var isAttack = false
    var timingString: String?
    var damageDice: FyreDiceModel = FyreDiceModel()
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
    
    var timing:ActionTiming { return ActionTiming(rawValue: timingString ?? "Long") ?? .Long }
    
    var damageFyreDice:FyreDice {
        return FyreDice(with: damageDice.dice, modifier: damageDice.modifier)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func < (lhs: Action, rhs: Action) -> Bool {
        if let lhsSpell = lhs.spell, let  rhsSpell = rhs.spell {
            if lhsSpell.level == rhsSpell.level {
                return lhsSpell.name < rhsSpell.name
            } else {
                return lhsSpell.level < rhsSpell.level
            }
        } else {
            return lhs.name < rhs.name
        }
    }
    
}

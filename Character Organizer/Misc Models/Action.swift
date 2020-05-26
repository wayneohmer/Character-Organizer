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

struct Action: Codable, Identifiable {
    
    var id = UUID()
    var name: String = ""
    var desc: String = ""
    var attack_bonus: Int?
    var damage_dice: String?
    var damage_bonus: Int?
    var damageType: String?
    var isPoficient = false
    var attrDamage = false
    var attrIndex = 0
    var isAttack = false
    var timingString: String?
    var damageDice: FyreDiceModel?
    var spell: Spell?
    var weapon: Equipment?
    
    var timing:ActionTiming { return ActionTiming(rawValue: timingString ?? "Long") ?? .Long }
    
    var damageFyreDice:FyreDice {
        return FyreDice(with: damageDice?.dice ?? [0:0], modifier: damageDice?.modifier ?? 0)
    }
    
}

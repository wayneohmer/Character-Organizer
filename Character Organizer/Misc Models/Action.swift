//
//  Action.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 3/22/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import Foundation

struct Action: Codable, Identifiable {
    
    var id = UUID()
    var name: String = ""
    var desc: String = ""
    var attack_bonus: Int?
    var damage_dice: String?
    var damage_bonus: Int?
    var isPoficient = false
    var attrIndex = 0
    var damageDice: FyreDiceModel?
    var spell: Spell?
    var weapon: Equipment?
    
    var damageFyreDice:FyreDice {
        return FyreDice(with: damageDice?.dice ?? [0:0], modifier: damageDice?.modifier ?? 0)
    }

    init(name:String, desc: String) {
        self.name = name
        self.desc = desc
    }
}

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
    var spell: Spell?

    init(name:String, desc: String) {
        self.name = name
        self.desc = desc
    }
}

//
//  Spell.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 2/16/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import Foundation

struct Spell: Codable, Viewable, Identifiable, Hashable, Comparable {
    
    static var shared = Set<Spell>()
    
    var description:String { return desc.joined(separator: "\n\n") }

    var id:String { return index }
    var index = ""
    var name = ""
    var desc = [String]()
    var range = ""
    var components = [String]()
    var material:String?
    var duration = ""
    var ritual = false
    var concentration = false
    var casting_time = ""
    var level = 0
    var school:Descriptor?
    var classes:[Descriptor]?
    var subclasses:[Descriptor]?
    var url = ""
    
    static func < (lhs: Spell, rhs: Spell) -> Bool {
        if lhs.level == rhs.level {
            return lhs.name < rhs.name
        } else {
            return lhs.level < rhs.level
        }
    }
    
    func hasClass(_ classes:Set<String>) -> Bool {
        
        for aClass in classes {
            for desc in self.classes ?? [Descriptor]() {
                if desc.name == aClass {
                    return true
                }
            }
        }
        return false
            
    }
    
    
    static func getSpells(){
        
        let path = Bundle.main.path(forResource: "5e-SRD-Spells", ofType: "json")!
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            do {
                let decoder = JSONDecoder()
                let all = try decoder.decode([Spell].self, from: data)
                shared.formUnion(Set(all))
                
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}

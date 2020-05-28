//
//  Spell.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 2/16/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import Foundation

struct Spell: Codable, Viewable, Identifiable, Hashable, Comparable {
   
    
    static var shared = [String: Spell]()
    
    var description:String {
        var str = desc.joined(separator: "\n\n")
        if let higherLevel = higher_level {
            str.append("\n\n\(higherLevel.joined(separator: "\n\n"))")
        }
        return str
        
    }

    var id:String { return index }
    var index = ""
    var name = ""
    var desc = [String]()
    var higher_level: [String]? 
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
    var damageDiceModel: FyreDiceModel?
    
    var damageDice:FyreDice? {
        if let model = damageDiceModel {
            return FyreDice(with: model)
        }
        return nil
    }
    
    var isAttack:Bool { return attackType != "" }
    
    var attackType: String {
        let regex = try! NSRegularExpression(pattern: "(melee|ranged) spell attack")
        let desc = self.desc.joined(separator: " ")
        let range = NSRange(location: 0, length: desc.count)
        let matches = regex.matches(in: desc, range: range)
        if matches.count > 0 {
            let val = matches.map {
                String(desc[Range($0.range, in: desc)!])
            }[0]
            
            let words = val.split(separator: " ").map(String.init)
            if words.count > 0 {
                return String(words[0])
            }
        }
        return ""
    }
    
    var saveType:String {
        let regex = try! NSRegularExpression(pattern: "(strength|dexteriy|constitution|intelligence|wisdom|charisma) saveing throw")
        let desc = self.desc.joined(separator: " ")
        let range = NSRange(location: 0, length: desc.count)
        let matches = regex.matches(in: desc, range: range)
        if matches.count > 0 {
            let val = matches.map {
                String(desc[Range($0.range, in: desc)!])
                }[0]
            
            let words = val.split(separator: " ").map(String.init)
            if words.count > 0 {
                return String(words[0])
            }
        }
        return ""
    }
    
    var damageType:String {
           let regex = try! NSRegularExpression(pattern: "(acid|bludgeoning|fire|cold|force|lightning|necrotic|piercing|poison|psychic|radiant|slashing|thunder) damage")
           let desc = self.desc.joined(separator: " ")
           let range = NSRange(location: 0, length: desc.count)
           let matches = regex.matches(in: desc, range: range)
           if matches.count > 0 {
               let val = matches.map {
                   String(desc[Range($0.range, in: desc)!])
                   }[0]
               
               let words = val.split(separator: " ").map(String.init)
               if words.count > 0 {
                return String(words[0]).capitalized
               }
           }
           return ""
       }
    
    var timeing: ActionTiming? {
        
        switch self.casting_time {
        case "1 action":
            return .Action
        case "1 reaction":
            return .Reaction
        case "1 bonus action":
            return .BonusAction
        default:
            return .Long
            
        }
        
    }
    
    var likelyDice: FyreDice? {
        
        let regex = try! NSRegularExpression(pattern: "(\\d\\d|\\d)d(\\d\\d|\\d) \\+ (\\d\\d|\\d)|(\\d\\d|\\d)d(\\d\\d|\\d)")
        let desc = self.desc.joined(separator: " ")
        let range = NSRange(location: 0, length: desc.count)
        let matches = regex.matches(in: desc, range: range)
        if matches.count > 0 {
            let val = matches.map {
                String(desc[Range($0.range, in: desc)!])
            }[0]
            
            let words = val.split(separator: " ").map(String.init)
            if words.count > 0 {
                let damageArray = words[0].split(separator: "d").map(String.init)
                if damageArray.count == 2 {
                    if let d = Int(damageArray[0]), let m = Int(damageArray[1]) {
                        let mod = words.count > 2 ? Int(words[2]) ?? 0 : 0
                        return FyreDice(with: [m:d], modifier: mod)
                    }
                }
            }
        }
        return nil
    }
    
    static func == (lhs: Spell, rhs: Spell) -> Bool {
        return lhs.index == rhs.index
    }
    
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
                let array = try decoder.decode([Spell].self, from: data)
                for item in array {
                    Spell.shared[item.index] = item
                }               
                
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}

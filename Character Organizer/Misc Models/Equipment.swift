//
//  Equipment.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/21/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import Foundation
import SwiftUI

struct Equipment: Codable, Viewable, Comparable, Identifiable, Hashable {
   
    
    static var shared = [String: Equipment]()
    
    var id:String { return name }
    var index = ""
    var name = ""
    var equipment_category = ""
    var weapon_category: String?
    var weapon_range: String?
    var armor_category: String?
    var tool_category: String?
    var vehicle_category: String?
    var category_range: String?
    var gear_category: String?
    var weight: Double?
    var properties: [Descriptor]?
    var url = ""
    var special:[String]?
    var desc:[String]?
    var damage: WeaponDamage?
    var range: WeaponRange?
    var armor_class: ArmorClass?
    var str_minimum: Int?
    var stealth_disadvantage: Bool? 

    
    var propertyDesc: String {
        return (self.properties ?? [Descriptor]()).map({ $0.name }).joined(separator: "\n")
    }
    
    var description: String {
        return (self.desc ?? [""]).joined(separator: "/n")
    }
    func hash(into hasher: inout Hasher) {
         hasher.combine(id)
    }
    
    static func == (lhs: Equipment, rhs: Equipment) -> Bool {
        return lhs.id == rhs.id
    }
       
    static func < (lhs: Equipment, rhs: Equipment) -> Bool {
        if lhs.equipment_category == rhs.equipment_category {
            if lhs.subcategory == rhs.subcategory {
                return lhs.name < rhs.name
            } else {
                return lhs.subcategory > rhs.subcategory
            }
        } else {
            return lhs.equipment_category < rhs.equipment_category
        }
    }
    
    var subcategory: String {
        
        var returnValue = ""
        switch equipment_category {
        case "Weapon":
            returnValue = category_range ?? ""
        case "Armor":
            returnValue = armor_category ?? ""
        case "Adventuring Gear":
            returnValue = gear_category ?? ""
        case "Tools":
            returnValue = tool_category ?? ""
        case "Mounts and Vehicles":
            returnValue = vehicle_category ?? ""
            
        default:
            break
        }
        
        
        return returnValue
    }
    
    static func getEquipment(){
        
        let path = Bundle.main.path(forResource: "5e-SRD-Equipment", ofType: "json")!
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            do {
                let decoder = JSONDecoder()
                let array = try decoder.decode([Equipment].self, from: data)
                for item in array {
                    Equipment.shared[item.index] = item
                }
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        EquipmentCatagories.getEquipment()
    }
}

struct EquipmentCost: Codable  {
    
    var quantity = Int(0)
    var unit:String?
}

struct WeaponDamage: Codable  {
    
    var damage_dice = ""
    var damage_bonus = Int(0)
    var damage_type: Descriptor?
}

struct ArmorClass: Codable  {
    
    var base = Int(0)
    var dex_bonus = false
    var max_bonus: Int?
}

struct WeaponRange: Codable  {
    
    var normal: Int?
    var long: Int?
}
    
struct EquipmentCatagories: Codable, Identifiable, Hashable {
    
    static var shared = [String: EquipmentCatagories]()
    
    var id:String { return name }
    var index = ""
    var name = ""
    var url = ""
    var equipment:[Descriptor]?
    
    static func getEquipment(){
        
        let path = Bundle.main.path(forResource: "5e-SRD-Equipment-Categories", ofType: "json")!
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            do {
                let decoder = JSONDecoder()
                let array = try decoder.decode([EquipmentCatagories].self, from: data)
                for item in array {
                    EquipmentCatagories.shared[item.index] = item
                }
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}


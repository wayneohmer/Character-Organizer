//
//  Equipment.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/21/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import Foundation

struct Equipment: Codable, Identifiable, Hashable {
    
    static var shared = [String: Equipment]()
    
    var id:String { return name }
    var index = ""
    var name = ""
    var equipment_category = ""
    var weapon_category: String?
    var weapon_range: String?
    var category_range: String?
    var gear_category: String?
    var weight: Double?
    var properties: [Descriptor]?
    var url = ""
    var special:[String]?
    var desc:[String]?

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

struct WeaponRange: Codable  {
    
    var damage_dice = ""
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


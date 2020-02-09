//
//  DamageType.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 2/9/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import Foundation

struct DamageType: Codable, Viewable, Identifiable, Hashable{
    
    static var shared:[String:DamageType] = [String:DamageType]()
    
    var description:String { return desc.joined(separator: "\n\n") }
    
    var id:String { return name }
    var index = ""
    var name = ""
    var desc = [String]()
    var url = ""
    
    static func getDamageTypes() {
        let path = Bundle.main.path(forResource: "5e-SRD-Damage-Types", ofType: "json")!
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            do {
                let decoder = JSONDecoder()
                let all = try decoder.decode([DamageType].self, from: data)
                for item in all {
                    shared[item.url] = item
                }
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
}

struct WeaponProperties: Codable, Viewable, Identifiable, Hashable{
    
    static var shared:[String:WeaponProperties] = [String:WeaponProperties]()
    
    var description:String { return desc.joined(separator: "\n\n") }
    
    var id:String { return name }
    var index = ""
    var name = ""
    var desc = [String]()
    var url = ""
    
    static func getWeaponProperties() {
        let path = Bundle.main.path(forResource: "5e-SRD-Weapon-Properties", ofType: "json")!
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            do {
                let decoder = JSONDecoder()
                let all = try decoder.decode([WeaponProperties].self, from: data)
                for item in all {
                    shared[item.url] = item
                }
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}

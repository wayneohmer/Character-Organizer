//
//  Skill.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/7/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import UIKit

struct Skill: Codable, Viewable, Identifiable, Hashable {
    
    static var shared = [String:Skill]()
    
    var description:String { return desc.joined(separator: "\n\n") }
    
    var id:String { return name }
    var name = ""
    var desc = [String]()
    var ability_score:Descriptor?
    var url = ""

    static func getSkills(){
        
        let path = Bundle.main.path(forResource: "5e-SRD-Skills", ofType: "json")!
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            do {
                let decoder = JSONDecoder()
                let all = try decoder.decode([Skill].self, from: data)
                for skill in all {
                    shared[skill.url] = skill
                }
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
}


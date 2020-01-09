//
//  Proficiency.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/7/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import UIKit

struct Proficiency: Codable, Viewable {
    
    static var shared = [String:Proficiency]()
        
    var index = ""
    var name = ""
    var type = ""
    var url = ""
    var description:String { return name }
    
    var skill:Skill? {
        
        var components = index.split(separator: "-")
        
        if components.count > 0 {
            components.removeFirst()
            let skill = String(components.joined(separator: "-"))
            return Skill.shared["/api/skills/\(skill)"]
        } else {
            return nil
        }
    }

    static func getProficiencies(){
        
        let path = Bundle.main.path(forResource: "5e-SRD-Proficiencies", ofType: "json")!
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            do {
                let decoder = JSONDecoder()
                let all = try decoder.decode([Proficiency].self, from: data)
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


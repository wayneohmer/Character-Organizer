//
//  Class.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/5/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import UIKit

class Class: NSObject {
    static var sharedClasses = [Class]()
    
    var model:ClassModel = ClassModel()
    var name:String { return model.name }
    var hitDie:Int { return model.hit_die }
    var proficiencyChoices:ChooseableOption? { return model.proficiency_choices?[0] ?? ChooseableOption()  }
    var proficiencies:[Descriptor]? { return model.proficiencies }
    var savingThrows:[Descriptor]? { return model.saving_throws }

    static func getClasses(){
        
        let path = Bundle.main.path(forResource: "5e-SRD-Classes", ofType: "json")!
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            do {
                let decoder = JSONDecoder()
                let classes = try decoder.decode([ClassModel].self, from: data)
                for model in classes {
                    let newClass = Class()
                    newClass.model = model
                    Class.sharedClasses.append(newClass)
                }
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
}

struct ClassModel: Codable {
    
    var name = ""
    var hit_die = Int(0)
    var proficiency_choices:[ChooseableOption]?
    var proficiencies:[Descriptor]?
    var saving_throws:[Descriptor]?
    var starting_equipment:ClassDeccripter?
    var spellcasting:ClassDeccripter?
}

struct ClassDeccripter: Codable {
    
    var characterClass = ""
    var url = ""
    
    private enum CodingKeys : String, CodingKey {
        case characterClass = "class", url
    }
}

//
//  Class.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/5/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import UIKit

class CharacterClass: HasProfOptions, Identifiable, Equatable {
   
    
    static var shared = [CharacterClass]()
    
    var id:String { name }
    var model:ClassModel = ClassModel()
    var name:String { return model.name }
    var hitDie:Int { return model.hit_die }
    var proficiencyChoices:ProficiencyChoices { return profChoices }
    var proficiencies:[Proficiency] {
        var returnValue = [Proficiency]()
        
        for descriptor in model.proficiencies ?? [Descriptor]() {
            if let prof = Proficiency.shared[descriptor.url] {
                returnValue.append(prof)
            }
        }
        return returnValue
    }
        
    var savingThrows:[Descriptor]? { return model.saving_throws }
    var selectedProficiencies = Set<Proficiency>()
    
    lazy var profChoices:ProficiencyChoices = {
        var returnValue = ProficiencyChoices()
        guard let choices = model.proficiency_choices?[0].from, let choose = model.proficiency_choices?[0].choose, let type = model.proficiency_choices?[0].type else {
            return returnValue
        }
        returnValue.choose = choose
        returnValue.type = type
        for descriptor in choices {
            if let prof = Proficiency.shared[descriptor.url] {
                returnValue.proficiencies.append(prof)
            }
        }
        return returnValue
    }()

    static func == (lhs: CharacterClass, rhs: CharacterClass) -> Bool {
         return lhs.name == rhs.name
    }
       
    static func getClasses(){
        
        let path = Bundle.main.path(forResource: "5e-SRD-Classes", ofType: "json")!
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            do {
                let decoder = JSONDecoder()
                let classes = try decoder.decode([ClassModel].self, from: data)
                for model in classes {
                    let newClass = CharacterClass()
                    newClass.model = model
                    CharacterClass.shared.append(newClass)
                }
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    convenience init(model:ClassModel){
        self.init()
        self.model = model
    }
    
}

class ProficiencyChoices: ChooseableOption {
    
    var choose: Int?
    var type: String?
    var from:[Viewable] { return proficiencies as [Viewable] }
    var proficiencies = [Proficiency]()

}

struct ClassModel: Codable {
    
    var name = ""
    var hit_die = Int(0)
    var proficiency_choices:[ChooseableOptionModel]?
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

//
//  Race.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/5/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import UIKit

class Race: Identifiable, Equatable, Comparable, ObservableObject {
    
    static var sharedRaces = [Race]()

    var model = RaceModel()
    var subrace = SubRace()
    var isSubrace = false

    var id:String { return name }
    var name:String { return isSubrace ? subrace.name : model.name }
    var speed:Int { return model.speed }
    var size:String { return model.size }
    var sizeDescription:String { return model.size_description }
    var age:String { return model.age }
    var abilityBonuses:[Ability]? { return isSubrace ? subrace.ability_bonuses : model.ability_bonuses }
    var startingProficiencies:[Descriptor]? { return isSubrace ? subrace.starting_proficiencies : model.starting_proficiencies }
    var startingChooseableOption:ChooseableOption? { return isSubrace ? subrace.starting_proficiency_options : model.starting_proficiency_options }
    var languageOptions:ChooseableOption? { return isSubrace ? subrace.language_options : model.language_options }
    var languages:[Descriptor]? { return isSubrace ? subrace.languages : model.languages }
    var traits:[Descriptor]? { return isSubrace ? subrace.traits : model.traits }
    var subraces:[Descriptor]?


    static func == (lhs: Race, rhs: Race) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: Race, rhs: Race) -> Bool {
        lhs.model.name < rhs.model.name
    }
    
    
}


struct RaceModel: Codable, Identifiable, Equatable {
    
    static var sharedRaceModels = [RaceModel]()
    static var sharedSubRaces = [SubRace]()

    var id:String { return name }
    var index = ""
    var name = ""
    var speed = Int(30)
    var size = ""
    var size_description = ""
    var age = ""
    var ability_bonuses:[Ability]?
    var starting_proficiencies:[Descriptor]?
    var starting_proficiency_options:ChooseableOption?
    var languages:[Descriptor]?
    var language_options:ChooseableOption?
    var traits:[Descriptor]?
    var subraces:[Descriptor]?

    var desc:String { return name }
    
    static func getRaces(){
        
        var path = Bundle.main.path(forResource: "5e-SRD-Races", ofType: "json")!
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            do {
                let decoder = JSONDecoder()
                 sharedRaceModels = try decoder.decode([RaceModel].self, from: data)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        path = Bundle.main.path(forResource: "5e-SRD-Subraces", ofType: "json")!
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            do {
                let decoder = JSONDecoder()
                    sharedSubRaces = try decoder.decode([SubRace].self, from: data)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        for raceModel in sharedRaceModels {
            let race = Race()
            race.model = raceModel
            Race.sharedRaces.append(race)
        }
        
        for subRace in sharedSubRaces {
            let race = Race()
            race.isSubrace = true
            race.subrace = subRace
            race.model = sharedRaceModels.first(where: { $0.name == subRace.raceName }) ?? RaceModel()
            Race.sharedRaces.append(race)
        }
        Race.sharedRaces.sort()
    }
    
    static func == (lhs: RaceModel, rhs: RaceModel) -> Bool {
        return lhs.name == rhs.name
    }
    
    
}

struct SubRace: Codable, Identifiable, Equatable {
        
    var id:String { return name }
    var index = ""
    var name = ""
    var ability_bonuses:[Ability]?
    var starting_proficiencies:[Descriptor]?
    var starting_proficiency_options:ChooseableOption?
    var languages:[Descriptor]?
    var language_options:ChooseableOption?
    var traits:[Descriptor]?
    var race:Descriptor?
    var desc:String?
    
    var raceName:String { return race?.name ?? "" }
    
    static func == (lhs: SubRace, rhs: SubRace) -> Bool {
        return lhs.name == rhs.name
    }
}

struct Ability: Codable {
    
    var name = ""
    var url = ""
    var bonus = Int(0)
}

struct ChooseableOption: Codable {
    var choose:Int?
    var type:String?
    var from:[Descriptor]?
}

struct Descriptor: Codable {
    
    var name = ""
    var url = ""
    
   
}

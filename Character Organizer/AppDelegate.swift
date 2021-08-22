//
//  AppDelegate.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 10/31/19.
//  Copyright © 2019 Tryal by Fyre. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let savedCharacterPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("characters")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        RaceModel.getRaces()
        Trait.getTraits()
        CharacterClass.getClasses()
        Skill.getSkills()
        Proficiency.getProficiencies()
        Equipment.getEquipment()
        DamageType.getDamageTypes()
        WeaponProperties.getWeaponProperties()
        Spell.getSpells()
        
        if  !FileManager.default.fileExists(atPath: savedCharacterPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: savedCharacterPath.path,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            } catch {
                print("Error creating images folder in documents dir: \(error)")
            }
        }

        self.getAllCharacters()
        
        if CharacterSet.shared.allCharacters.count == 0 {
            
            Character.shared.charcaterClass = CharacterClass.shared[0]
            Character.shared.name = "Boris"
            Character.shared.race = Race.shared[0]
            for descriptor in Character.shared.race.startingProficiencies ?? [Descriptor]() {
                if let prof = Proficiency.shared[descriptor.url] {
                    Character.shared.model.proficiencies.insert(prof)
                }
            }
            Character.shared.model.proficiencies.formUnion(Set(Character.shared.charcaterClass.proficiencies))
            Character.shared.model.skills.insert(Skill.shared["/api/skills/animal-handling"] ?? Skill())
            Character.shared.model.skills.insert(Skill.shared["/api/skills/athletics"] ?? Skill())
            Character.shared.model.equipment = [Equipment.shared["camel"] ?? Equipment(), Equipment.shared["plate"] ?? Equipment(), Equipment.shared["longsword"] ?? Equipment()]
            Character.shared.model.spells = [Spell.shared["Light"] ?? Spell(), Spell.shared["Magic Missile"] ?? Spell(), Spell.shared["Melf's Acid Arrow"] ?? Spell(), Spell.shared["Shield"] ?? Spell() , Spell.shared["Spiritual Weapon"] ?? Spell()]
            Character.shared.level = "2"
            Character.shared.armorClass = "10"
            Character.shared.speed = "10"
            Character.shared.maxHP = "35"
            Character.shared.currentHP = "35"
            Character.shared.tempHP = "0"
            Character.shared.str = "16"
            Character.shared.dex = "15"
            Character.shared.con = "17"
            Character.shared.int = "9"
            Character.shared.wis = "7"
            Character.shared.cha = "20"
            Character.shared.casterAttributeIdx = 5
            Character.shared.proficiencyBonus = "2"
            Character.shared.model.actions = Set<Action>()
            Character.shared.model.proficientSaves = Set<Int>()
            Character.shared.model.isActive = true
            for spell in Character.shared.model.spells {
                Character.shared.addSpellAction(spell)
            }
            CharacterSet.shared.allCharacters.insert(Character.shared.model)
            var model2 = Character.shared.model
            model2.name = "Dingus"
            CharacterSet.shared.allCharacters.insert(model2)
        } else {
            Character.shared =  Character(model:CharacterSet.shared.allCharacters.sorted()[0])
        }

        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func getAllCharacters() {
        guard let dir = try? FileManager.default.contentsOfDirectory(atPath: savedCharacterPath.path) else { return }
        for path in dir {
            guard let url = URL(string: savedCharacterPath.appendingPathComponent(path).absoluteString) else { break }
            do {
                let characterData = try Data(contentsOf: url)
                do {
                    var model = try JSONDecoder().decode(CharacterModel.self, from: characterData)
                    var actionArray = Array(model.actions)
                    for (idx, _) in actionArray.enumerated() {
                        actionArray[idx].convertDamage()
                    }
                    model.actions = Set(actionArray.filter({ $0.name != "" }))
                    
                    CharacterSet.shared.allCharacters.insert(model)
                } catch {
                    print(error)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


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



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .black
        UITableViewCell.appearance().backgroundColor = .black
        RaceModel.getRaces()
        Trait.getTraits()
        CharacterClass.getClasses()
        Skill.getSkills()
        Proficiency.getProficiencies()
        Equipment.getEquipment()
        Character.shared.charcaterClass = CharacterClass.shared[0]
        Character.shared.name = "Boris"
        Character.shared.race = Race.shared[0]
        Character.shared.level = "2"
        Character.shared.armorClass = "10"
        Character.shared.speed = "10"
        Character.shared.currentHP = "35"
        Character.shared.str = "16"
        Character.shared.dex = "15"
        Character.shared.con = "17"
        Character.shared.int = "9"
        Character.shared.wis = "7"
        Character.shared.cha = "20"
        Character.shared.model.actions = [Action(name: "Action1", desc: "Action 1 description Action 1 description Action 1 description Action 1 description Action 1 description Action 1 description Action 1 description Action 1 description Action 1 description Action 1 description Action 1 description Action 1 description Action 1 description Action 1 description Action 1 description Action 1 description Action 1 description Action 1 description "),Action(name: "Action2", desc: "Action 2 description"),Action(name: "Action3", desc: "Action 3 description")]
        
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


}


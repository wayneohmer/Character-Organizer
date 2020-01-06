//
//  Traits.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/5/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import Foundation

struct Trait: Codable {
    
    static var sharedTraits:[String:Trait] = [String:Trait]()
    
    var index = ""
    var name = ""
    var desc = [String]()
    var url = ""
    
    static func getTraits(){
    
    let path = Bundle.main.path(forResource: "5e-SRD-Traits", ofType: "json")!
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        do {
            let decoder = JSONDecoder()
            let allTraits = try decoder.decode([Trait].self, from: data)
            for trait in allTraits {
                sharedTraits[trait.url] = trait
            }
        } catch {
            print(error)
        }
    } catch {
        print(error)
    }
        
    }
}

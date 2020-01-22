//
//  utiliyStructs.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/21/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import Foundation

protocol ChooseableOption {
    var choose:Int? { get }
    var type:String? { get }
    var from:[Viewable] { get }
}


struct ChooseableOptionModel: Codable {
    var choose:Int?
    var type:String?
    var from:[Descriptor]?
}

struct Descriptor: Codable, Identifiable, Hashable {
    
    var id:String { return name }
    var name = ""
    var url = ""
    var selected:Bool? = false

}

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

class DiceParcer {
    class func likelyDice(_ text: String) -> FyreDice? {
           
           let regex = try! NSRegularExpression(pattern: "(\\d\\d|\\d)d(\\d\\d|\\d) \\+ (\\d\\d|\\d)|(\\d\\d|\\d)d(\\d\\d|\\d)")
           let range = NSRange(location: 0, length: text.count)
           let matches = regex.matches(in: text, range: range)
           if matches.count > 0 {
               let val = matches.map {
                   String(text[Range($0.range, in: text)!])
               }[0]
               
               let words = val.split(separator: " ").map(String.init)
               if words.count > 0 {
                   let damageArray = words[0].split(separator: "d").map(String.init)
                   if damageArray.count == 2 {
                       if let d = Int(damageArray[0]), let m = Int(damageArray[1]) {
                           let mod = words.count > 2 ? Int(words[2]) ?? 0 : 0
                           return FyreDice(with: [m:d], modifier: mod)
                       }
                   }
               }
           }
           return nil
       }
}

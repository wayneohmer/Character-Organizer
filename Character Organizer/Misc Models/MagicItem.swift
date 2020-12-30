//
//  MagicItem.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 12/27/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct MagicItem: Codable, Viewable, Identifiable, Hashable, Comparable {

    var id:String { return name }
    var name = ""
    var desc = ""
    var requiresAttunement = false
    var attuned = false
    var equipped = false
    var isAction = false
    var action: Action?
    var equipment: Equipment?
    
    var description: String {
        return desc
    }
    
    static func < (lhs: MagicItem, rhs: MagicItem) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func == (lhs: MagicItem, rhs: MagicItem) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    mutating func getPastedString() {
        
        guard let pastedString = UIPasteboard.general.string, pastedString != "" else {
            return
        }
        var firstLine = ""
        let regex = try! NSRegularExpression(pattern: "(.*)(\\r|\\n)")
        let range = NSRange(location: 0, length: pastedString.count)
        let matches = regex.matches(in: pastedString, range: range)
        if matches.count > 0 {
            firstLine = matches.map {
                String(pastedString[Range($0.range, in: pastedString)!])
                }[0]
            self.name = firstLine.capitalized
            self.desc = String(pastedString.dropFirst(firstLine.count))
        }
        
    }
}

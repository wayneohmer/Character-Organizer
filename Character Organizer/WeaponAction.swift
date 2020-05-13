//
//  WeaponAction.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 5/13/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct WeaponAction: View {
    
    var action:Action
    @State var showingDice = false
    
    var body: some View {
        VStack {
            Text(action.name).font(Font.system(size: 25, weight: .bold, design:
                .default)).padding(4)
            HStack{
                Text("Weapon:")
                Text(self.attackBonus())
                Text("damage: \(action.damageFyreDice.display)")
                Text(self.damagebonus())
                Text(action.weapon?.damage?.damage_type?.name ?? "")
                Spacer()
            }
        }.onTapGesture {
            self.showingDice = true
        }
        .sheet(isPresented: self.$showingDice, content: {
            DiceView(details: DiceDetails(title:self.action.name), dice: FyreDice(with: [20:1], modifier: Character.shared.attrBonusArray[self.action.attrIndex] + (self.action.attack_bonus ?? 0)))
        })
        .foregroundColor(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
        .background(Color(.black))
    }
    
    func attackBonus() -> String {
        let bonus = Character.shared.attrBonusArray[action.attrIndex] + (action.attack_bonus ?? 0)
        if bonus == 0 {
            return ""
        } else {
            return bonus > 0 ? "+\(bonus)" : "\(bonus)"
        }
    }
    
    func damagebonus() -> String {
        let bonus = Character.shared.attrBonusArray[action.attrIndex] + (action.damage_bonus ?? 0)
        if bonus == 0 {
            return ""
        } else {
            return bonus > 0 ? "+\(bonus)" : "\(bonus)"
        }
        
    }
    
}

struct WeaponAction_Previews: PreviewProvider {
    static var previews: some View {
        WeaponAction(action: Action(name: "Weapon", desc: "Woot"))
    }
}

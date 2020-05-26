//
//  WeaponAction.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 5/13/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct SpellAction: View {
    
    var action:Action
    @State var showingDice = false
    @State var showDesc = false
    
    var body: some View {
        VStack {
            Text(action.name).font(Font.system(size: 25, weight: .bold, design:
                .default)).padding(4)
            HStack{
                Text("Spell:")
                Text("level: \(action.spell?.level ?? 0)" )
                Text("Casting Time: \(action.spell?.casting_time ?? "")")
                Text("Range: \(action.spell?.range ?? "")")
                if action.damageDice != nil {
                    Text("Damage: \(action.damageFyreDice.display)")
                }
                Spacer()
            }
            HStack{
                Button(action: { self.showDesc.toggle()}, label: { Text (self.showDesc ? " - " : " + ") })
                Spacer()
            }
            if showDesc {
                Text(action.spell?.desc.joined(separator: "\n") ?? "")
            }
        }.onTapGesture {
            self.showingDice = true
        }.padding()
        .sheet(isPresented: self.$showingDice, content: {
            self.sheetView
        })
        .foregroundColor(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
        .background(Color(.black))
        
    }
    
    var sheetView: some View {
        var myView = AnyView(DetailView(detail:self.action.spell ?? Spell()))
        if self.action.isAttack {
            myView = AnyView(AttackDiceView(details: DiceDetails(title:self.action.name), dice: FyreDice(with: [20:1], modifier: self.attackBonus()), damageDice: FyreDice(with: self.action.damageDice?.dice ?? [:], modifier: self.damageBonus())))
        } else if let diceModel = self.action.damageDice {
            myView = AnyView(ModalDiceView(details: DiceDetails(title:self.action.name), dice: FyreDice(with: diceModel)))
        }
        return myView
        
    }
    
    func attackBonus() -> Int {
        return Character.shared.attrBonusArray[action.attrIndex] + (action.attack_bonus ?? 0)
    }
    
    func damageBonus() -> Int {
        return (action.attrDamage ? Character.shared.attrBonusArray[action.attrIndex] : 0) + (action.damage_bonus ?? 0)
    }
    
}

struct SpellAction_Previews: PreviewProvider {
    static var previews: some View {
        SpellAction(action: Action(name: "Spell", desc: "Woot"))
    }
}

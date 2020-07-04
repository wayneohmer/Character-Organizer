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
            HStack {
                GrayButton(text: self.showDesc ? " - " : " + ", width: 30, height:30,  action: {
                    withAnimation(.default,  { self.showDesc.toggle() } )
                })
                Spacer()
                Text(action.name).font(Font.system(size: 20, weight: .bold, design: .default))
                Spacer()

            }.padding(4)
            HStack {
                Text("Spell:")
                Text("level: \(action.spell?.level ?? 0)" )
                Text("Casting Time: \(action.spell?.castingTime ?? "")")
                Text("Range: \(action.spell?.range ?? "")")
                Text("Damage: \(action.damageFyreDice.display)")
                Spacer()
            }
           
            if showDesc {
                Text(action.spell?.description ?? "")
            }
        }
        .padding(5)
        .foregroundColor(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
        .background(Color(.black).opacity(0.7))
        .onTapGesture {
            self.showingDice = true
        }
        .sheet(isPresented: self.$showingDice, content: {
            self.sheetView
                ScrollView {
                    Text(self.action.spell?.description ?? "")
                        .background(Color(.black))
                        .foregroundColor(Color(.white))
                }.padding()
            .background(Color(.black))
                
            })
       
    }
    
    var sheetView: some View {
        var myView = AnyView(DetailView(detail:self.action.spell ?? Spell()))
        if self.action.isAttack {
            myView = AnyView(AttackDiceView(details: DiceDetails(title:self.action.name), dice: FyreDice(with: [20:1], modifier: self.attackBonus()), damageDice: FyreDice(with: self.action.damageDice.dice, modifier: self.damageBonus()), damageType: self.action.damageType ?? " "))
        } else if self.action.damageDice.dice.count > 0 {
            myView = AnyView(ModalDiceView(details: DiceDetails(title:self.action.name), dice: FyreDice(with: self.action.damageDice)))
        }
        return myView
        
    }
    
    func attackBonus() -> Int {
        return Character.shared.attrBonusArray[action.attrIndex] + (action.attack_bonus)
    }
    
    func damageBonus() -> Int {
        return (action.attrDamage ? Character.shared.attrBonusArray[action.attrIndex] : 0) + (action.damage_bonus)
    }
    
}

struct SpellAction_Previews: PreviewProvider {
    static var previews: some View {
        SpellAction(action: Action(name: "Spell", desc: "Woot"))
    }
}

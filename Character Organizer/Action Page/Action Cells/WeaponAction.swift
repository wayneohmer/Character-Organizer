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
    @State var showDesc = false

    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    withAnimation(.default,  { self.showDesc.toggle() } )
                }, label: {Image(self.showDesc ? "arrowDown" : "arrowLeft").resizable() }).frame(width: 30, height: 30)
                Text(action.name).font(Font.system(size: 20, weight: .bold, design: .default))
                Spacer()
                
            }.padding(4)
            
            HStack{
                Text("Weapon:")
                Text("\(Character.AttributeArray[action.attrIndex])")
                Text(self.attackBonusString())
                Text("damage: \(action.damageFyreDice.display)")
                Text(self.damagebonusString())
                Text(action.damageType ?? "")
                Spacer()
            }
            if showDesc {
                HStack {
                    Text(action.desc)
                    Spacer()
                }
            }
        }.onTapGesture {
            self.showingDice = true
        }.padding(5)
            .sheet(isPresented: self.$showingDice, content: {
                AttackDiceView(details: DiceDetails(title:self.action.name), dice: FyreDice(with: [20:1], modifier: self.attackBonus()), damageDice: FyreDice(with: self.action.damageDice.dice, modifier: self.damageBonus()), damageType: self.action.damageType ?? " ")
            })
            .foregroundColor(Color.white)
            .background(Color(.black).opacity(0.8))
            
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
        
    }
    
    func attackBonus() -> Int {
        return Character.shared.attrBonusArray[action.attrIndex] + (action.attack_bonus) + (action.isProficient ? Character.shared.model.proficiencyBonus : 0)
    }
    
    func damageBonus() -> Int {
        return (action.attrDamage ? Character.shared.attrBonusArray[action.attrIndex] : 0) + (action.damage_bonus)
    }
    
    func attackBonusString() -> String {
        let bonus = self.attackBonus()
        if bonus == 0 {
            return ""
        } else {
            return bonus > 0 ? "+\(bonus)" : "\(bonus)"
        }
    }
    
    func damagebonusString() -> String {
        let bonus = self.damageBonus()
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

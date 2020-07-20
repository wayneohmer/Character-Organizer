//
//  WeaponAction.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 5/13/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct MiscAction: View {
    
    var action:Action
    @State var showingDice = false
    @State var showDesc = false
    
    var body: some View {
        VStack {
            HStack {
                GrayButton(text: self.showDesc ? " - " : " + ", width: 30, height:30,  action: {
                    withAnimation(.default,  { self.showDesc.toggle() } )
                })
                Text(action.name).font(Font.system(size: 20, weight: .bold, design: .default))
                Spacer()

            }.padding(4)
           
            if showDesc {
                Text(action.description)
            }
        }
        .padding(5)
        .foregroundColor(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
        .background(Color(.black).opacity(0.8))
        .onTapGesture {
            self.showingDice = true
        }
        .sheet(isPresented: self.$showingDice, content: {
            self.sheetView
                ScrollView {
                    Text(self.action.desc)
                        .background(Color(.black))
                        .foregroundColor(Color(.white))
                }.padding()
            .background(Color(.black))
                
            })
       
    }
    
    var sheetView: some View {
        var myView = AnyView(DetailView(detail:self.action))
        if self.action.damageDice.dice.count > 0 {
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

struct MiscAction_Previews: PreviewProvider {
    static var previews: some View {
        MiscAction(action: Action(name: "Misc", desc: "Woot"))
    }
}

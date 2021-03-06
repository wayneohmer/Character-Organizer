//
//  WeaponAction.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 5/13/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct SpellAction: View {
    
    @EnvironmentObject var character: Character

    var action:Action
    @State var showingDice = false
    @State var castTouched = false
    @State var showingCastAt = false
    @State var showDesc = false
    var spell:Spell { return self.action.spell ?? Spell() }
    
    var body: some View {
        VStack {
            HStack {
                
                Button(action: {
                    withAnimation(.default,  { self.showDesc.toggle() } )
                }, label: {Image(self.showDesc ? "arrowDown" : "arrowLeft").resizable() }).frame(width: 30, height: 30)
               
                Text(action.name).font(Font.system(size: 20, weight: .bold, design: .default))
                    //.offset(x:spell.isAttack ? 40 : 0)
                Spacer()
                if spell.isAttack {
                    GrayButton(text: "Attack", width: 80, action: {
                        self.showingDice = true
                    })
                }
                
            }.padding(4)
            if showDesc {
                HStack {
                    SpellHeader(spell: action.spell!)
                    Spacer()
                    }
                .offset(x: -5, y: 0)
                .padding(8)
                Text(action.spell?.description ?? "")
            } else {
                HStack {
                    Text("lvl:")
                    Text("\(action.spell?.level ?? 0)" ).fontWeight(.bold)
                    Text("Speed:")
                    Text("\(action.spell?.castingTime ?? "")").fontWeight(.bold)
                    Text("Range:")
                    Text("\(action.spell?.range ?? "")").fontWeight(.bold)
                    if action.damageFyreDice.display != " " {
                        Text("Dmg:")
                        Text("\(action.damageFyreDice.display)").fontWeight(.bold)
                    }
                    if action.spell?.isConcentration ?? false {
                        Text("Concentration").fontWeight(.bold)
                    }
                    if action.spell?.saveType ?? ""  != ""{
                        Text("\(action.spell?.saveType ?? "") save").fontWeight(.bold)
                    }
                    Spacer()
                }
            }
            
            
        }
        .padding(5)
        .foregroundColor(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
        .background(Color(.black).opacity(0.8))
        .onTapGesture {
            self.showingCastAt = true
        }
        .popover(isPresented: self.$showingCastAt, arrowEdge: .bottom, content: {
            CastAtView(castTouched:self.$castTouched, level: self.action.spell?.level ?? 1  ).environmentObject(self.character)
                .onDisappear(
                    perform: {
                        if self.castTouched {
                            if self.action.isAttack || self.action.damageDice.display != " " {
                                self.showingDice = true
                            }
                            self.castTouched = false
                        }
                })
        })
            .sheet(isPresented: self.$showingDice, content: {
                self.sheetView
                if self.action.isAttack || self.action.damageDice.dice.count > 0 {
                    ScrollView {
                        Text(self.action.spell?.description ?? "")
                            .background(Color(.black))
                        .foregroundColor(Color(.white))
                }.padding()
            .background(Color(.black))
            }
            
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

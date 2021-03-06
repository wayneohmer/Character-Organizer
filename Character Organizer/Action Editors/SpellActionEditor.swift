//
//  SpellActionEditor.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 5/28/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct SpellActionEditor: View  {
    
    let damageTypes:[String] = DamageType.shared.map({$0.value.name}).sorted()

    @State var action: Action
    @State var showingSpellDice = false
    @State var showAttack = false
    @EnvironmentObject var character: Character

    @State var damageTypeIdx = 0
    @State var isProficient = true
    @State var toHitBonus:String = "0"
    @State var damageBonus:String = "0"
    @State var damageDice = FyreDice()    
    
    var spell:Spell { return action.spell ?? Spell() }
    var background = Color(red: 0.07, green: 0.07, blue: 0.07)

    var body: some View {
        VStack {
            
            HeaderBarView(name: action.name, saveAction:self.saveAction, deleteAction: self.deleteAction)
            
            HStack {
                VStack (alignment: .leading){
                    SpellHeader(spell: spell).padding()
                    VStack(alignment: .leading) {
                        VStack {
                            HStack {
                                Toggle(isOn: $action.isAttack ) { Text("Attack?")}.frame(width: 130, height: 40)
                                Spacer()
                            }
                            if action.isAttack {
                                AttackCreationView(spell: self.spell, action: self.$action)
                            } else {
                                HStack {
                                    Text("Dice:")
                                    Text(action.damageFyreDice.display)
                                        .onTapGesture {
                                            self.showingSpellDice = true
                                    }
                                    .frame(width: 75, height:30)
                                    .background(Color.white)
                                    .foregroundColor(Color.black)
                                    .cornerRadius(5)
                                    .popover(isPresented: $showingSpellDice, content: {
                                        DicePickerView(details: DiceDetails(title: self.action.name), diceModel: self.$action.damageDice, hasModifier: true)
                                    })
                                    Spacer()
                                    
                                }
                            }
                        }
                    }.padding()
                    .background(Color(.black))
                }
            Spacer()
            }

            ScrollView {
                Text(spell.description).fontWeight(.bold)
            }.padding()

            Spacer()
        }
        .background(background)
        .foregroundColor(.white)
        
    }
    
    func saveAction(){
        if let action = Character.shared.model.actions.filter({$0.name == self.action.name}).first {
            Character.shared.model.actions.remove(action)
        }
        self.action.damageType = DamageType.shared.map({$0.value.name}).sorted()[action.damageTypeIndex]
        self.action.weapon = nil
        Character.shared.model.actions.insert(self.action)
    }
    
    func deleteAction() {
        if let action = Character.shared.model.actions.filter({$0.name == self.action.name}).first {
            Character.shared.model.actions.remove(action)
        }
    }
    
}

struct SpellActionEditor_Previews: PreviewProvider {
    static var previews: some View {
        SpellActionEditor(action:Action(weapon: Equipment()))
    }
}

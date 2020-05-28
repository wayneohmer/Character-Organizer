//
//  SpellActionEditor.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 5/28/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct SpellActionEditor: View  {
    
    @Environment(\.presentationMode) var presentationMode

    var action: Action
    @State var isAttack = false
    @State var showingSpellDice = false
    @State var showAttack = false
    var spell:Spell { return action.spell ?? Spell() }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("Close").fontWeight(.bold).padding(5).offset(y:-2)
                }.frame(width: 100, height: 50, alignment: .center)
                
            }
            Text(spell.name).font(.title).foregroundColor(Color.white).padding(5)
            HStack {
                VStack (alignment: .leading){
                    SpellHeader(spell: spell)
                    VStack(alignment: .leading) {
                        HStack {
                            Toggle(isOn: $isAttack ) { Text("Attack?")}.frame(width: 130, height: 40)
                            if isAttack {
                                GrayButton(text: "Edit Attack", width: 150, action: {
                                    self.showAttack = true
                                })
                                    .sheet(isPresented: self.$showAttack, content: {
                                        AttackCreationView(spell: self.spell)
                                    })
                            } else {
                                Text("Dice:")
                                Text(self.spell.likelyDice?.display ?? "")
                                    .onTapGesture {
                                        self.showingSpellDice = true
                                }
                                .frame(width: 75, height:30)
                                .background(Color.white)
                                .foregroundColor(Color.black)
                                .cornerRadius(5)
                                .popover(isPresented: $showingSpellDice, content: {
                                    DicePickerView(details: DiceDetails(title: self.action.name), dice: FyreDice(with: self.action.damageDice ?? FyreDiceModel()))
                                })
                            }
                        }
                    }
                }
                Spacer()
            }
            ScrollView {
                Text(spell.description).fontWeight(.bold)
            }
            Spacer()
        }
        .padding()
        .background(Color(.black))
        .foregroundColor(.white)
    }
    
}

struct SpellActionEditor_Previews: PreviewProvider {
    static var previews: some View {
        SpellActionEditor(action:Action())
    }
}

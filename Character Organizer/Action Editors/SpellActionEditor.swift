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
    let damageTypes:[String] = DamageType.shared.map({$0.value.name}).sorted()

    @State var action: Action
    @State var isAttack = false
    @State var showingSpellDice = false
    @State var showAttack = false
    @State var showAlert = false
    @ObservedObject var character = ObCharacer().character
    
    @State var selectedAttr = 0
    @State var damageTypeIdx = 0
    @State var isProficient = true
    @State var attrDamage = true
    @State var toHitBonus:String = "0"
    @State var damageBonus:String = "0"
    @State var damageDice = FyreDice()    
    
    var spell:Spell { return action.spell ?? Spell() }
    
    var body: some View {
        VStack {
            HStack {
                GrayButton(text: "Detete", width: 100, color:Color(.red), action: {
                    self.showAlert = true
                })
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Are You Sure?"),
                              primaryButton: .destructive(Text("Die"), action: {
                                self.deleteAction()
                                self.presentationMode.wrappedValue.dismiss()
                              }),
                              secondaryButton: .cancel(Text("NO!")))
                }
                
                Spacer()
                GrayButton(text: "Save", width: 100, color:Color(.green), action:{
                    self.presentationMode.wrappedValue.dismiss()
                    self.saveAction()
                })
            }
            Text(spell.name).font(.title).foregroundColor(Color.white).padding(5)
            HStack {
                VStack (alignment: .leading){
                    SpellHeader(spell: spell)
                    VStack(alignment: .leading) {
                        VStack {
                            HStack {
                                Toggle(isOn: $isAttack ) { Text("Attack?")}.frame(width: 130, height: 40)
                                Spacer()
                            }
                            if isAttack {
                                AttackCreationView(spell: self.spell, action: self.$action)
                            } else {
                                HStack {
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
                                    Spacer()
                                    
                                }
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
        .onAppear(){
            self.isAttack = self.action.isAttack
        }
    }
    
    func saveAction(){
        self.action.attrIndex = self.selectedAttr
        self.action.attrDamage = self.attrDamage
        self.action.damageDice = self.damageDice.model
        self.action.damageType = self.damageTypes[self.damageTypeIdx]
        if let action = self.character.model.actions.filter({$0.name == self.action.name}).first {
            self.character.model.actions.remove(action)
        }
        self.character.model.actions.insert(self.action)
    }
    
    func deleteAction() {
    }
    
}

struct SpellActionEditor_Previews: PreviewProvider {
    static var previews: some View {
        SpellActionEditor(action:Action())
    }
}

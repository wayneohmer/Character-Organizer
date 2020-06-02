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
    @State var showingSpellDice = false
    @State var showAttack = false
    @State var showAlert = false
    @ObservedObject var character = ObCharacer().character
    
    @State var damageTypeIdx = 0
    @State var isProficient = true
    @State var toHitBonus:String = "0"
    @State var damageBonus:String = "0"
    @State var damageDice = FyreDice()    
    
    var spell:Spell { return action.spell ?? Spell() }
    var background = Color(red: 0.07, green: 0.07, blue: 0.07)
    var foreground = Color(red: 0.40, green: 0.40, blue: 0.40)

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
                Text(action.name).font(.title).foregroundColor(Color.white).padding(5)
                Spacer()
                GrayButton(text: "Save", width: 100, color:Color(.green), action:{
                    self.presentationMode.wrappedValue.dismiss()
                    self.saveAction()
                })
            }
            .padding(3)
            .background(LinearGradient(gradient: Gradient(colors: [foreground, .black]), startPoint: .top, endPoint: .bottom))
            
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
        if let action = self.character.model.actions.filter({$0.name == self.action.name}).first {
            self.character.model.actions.remove(action)
        }
        self.action.damageType = DamageType.shared.map({$0.value.name}).sorted()[action.damageTypeIndex]
        self.character.model.actions.insert(self.action)
    }
    
    func deleteAction() {
        if let action = self.character.model.actions.filter({$0.name == self.action.name}).first {
            self.character.model.actions.remove(action)
        }
    }
    
}

struct SpellActionEditor_Previews: PreviewProvider {
    static var previews: some View {
        SpellActionEditor(action:Action(name:"Spell"))
    }
}

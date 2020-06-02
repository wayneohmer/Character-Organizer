//
//  AttackCreationView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 3/22/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct AttackCreationView: View {
    
    var weapon:Equipment?
    var spell:Spell?
    let damageTypes:[String] = DamageType.shared.map({$0.value.name}).sorted()
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var character = ObCharacer().character
    @State var selectedType = 0
    @State var damageTypeIdx = 0
    
    @Binding var action:Action
    
    var background = Color(red: 0.15, green: 0.15, blue: 0.15)
    @State var showingToHitBonus = false
    @State var showingDamageBonus = false
    @State var showingDamageDice = false
    @State var desc = ""
    @State var isNew = true
    
    var oldAction:Action?
    var diceDetails = DiceDetails()
    @State var damageDice = FyreDice()
    
    var body: some View {
        VStack {
//            HStack {
//                Spacer()
//                Button(action: {
//                    self.updateAction()
//                    self.character.model.actions.insert(self.action)
//                    self.presentationMode.wrappedValue.dismiss()
//                } ) {
//                    Text("\(self.isNew ? "Save" : "Copy")").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
//                }.frame(width: 100, height: 50, alignment: .center)
//                if !self.isNew {
//                    Button(action: {
//                        self.updateAction()
//                        self.character.model.actions.insert(self.action)
//                        self.presentationMode.wrappedValue.dismiss()
//                    } ) {
//                        Text("Replace").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
//                    }.frame(width: 100, height: 50, alignment: .center)
//                }
//            }
//            TextField("Name",text: self.$action.name).font(Font.system(size: 30, weight: .bold, design: .default))
//                .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
//                .multilineTextAlignment(.center)
//                .background(Color.white)
//                .foregroundColor(Color.black)
//                .padding(16)
            HStack{
                Text("Attribute:")
                Picker("", selection: self.$action.attrIndex) {
                    ForEach(0 ..< Character.AttributeArray.count) { index in
                        Text(Character.AttributeArray[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Color(.lightGray))
                .cornerRadius(8)
            }
            HStack {
                VStack {
                    HStack {
                    Text("To Hit: \(self.toHitTotal())").font(Font.system(size: 20, weight: .bold, design: .default))
                        Spacer()
                    }
                    HStack {
                        Toggle(isOn:self.$action.isProficient) {
                            Text("Proficient:")
                        }.frame(width:150)
                        Text("Bonus:")
                        Text("\(self.action.attack_bonus)")
                            .onTapGesture {
                                self.showingToHitBonus = true
                        }
                        .frame(width: 45, height:30)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(5)
                        .popover(isPresented: $showingToHitBonus, content: {
                            NumberEditor(value: "0", modifiedValue: self.$action.attack_bonus , isHP: false)
                        })
                        
                        Spacer()
                    }
                    HStack{
                        Text("Damage: \(self.damageTotal())").font(Font.system(size: 20, weight: .bold, design: .default))
                        Spacer()
                    }
                    HStack {
                        Text("Dice:")
                        Text(action.damageFyreDice.display).onTapGesture {
                            self.showingDamageDice = true
                        }
                        .frame(width: 70, height:30)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(5)
                        .popover(isPresented: $showingDamageDice, content: {
                            DicePickerView(details: DiceDetails(title: self.action.name), diceModel: self.$action.damageDice)
                        })
                        Text("Bonus:")
                        Text("\(action.damage_bonus)").onTapGesture {
                            self.showingDamageBonus = true
                        }
                        .frame(width: 45, height:30)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(5)
                        .popover(isPresented: $showingDamageBonus, content: {
                            NumberEditor(value: "0", modifiedValue: self.$action.damage_bonus, isHP: false)
                        })
                        Toggle(isOn:$action.attrDamage) {
                            Text("Add Attrbiute:")
                        }.frame(width:170)
                        Spacer()
                    }
                }
                HStack {
                    Text("Type:")
                    Picker("", selection: $action.damageTypeIndex) {
                        ForEach(0 ..< self.damageTypes.count) { index in
                            Text(String(self.damageTypes[index]))
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .background(Color(.lightGray))
                    .frame(width: 170, height: 100)
                    .cornerRadius(8)
                }
            }
            
            
//            TextField("Description",text: $desc)
//                .frame(height: 50, alignment: .center)
//                .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
//                .multilineTextAlignment(.center)
//                .background(Color.white)
//                .foregroundColor(Color.black)
            Spacer()
        }
        .padding()
        .foregroundColor(Color.white)
        .background(Color(.black))
        .onAppear(){
            if let oldAction = self.oldAction {
                self.action.name = oldAction.name
                self.action.weapon = oldAction.weapon
                self.action.spell = oldAction.spell
                self.selectedType = oldAction.weapon != nil ? 0 : 1
                self.action.attrIndex = oldAction.attrIndex
                self.action.isProficient = oldAction.isProficient
                self.damageDice = FyreDice(with: oldAction.damageDice)
                self.damageTypeIdx = self.damageTypes.firstIndex(of: oldAction.damageType ?? "") ?? 0
                self.desc = oldAction.desc
                self.isNew = false
            } else {
                self.damageTypeIdx = self.damageTypes.firstIndex(of: self.action.damageType ?? "") ?? 0
                if let weapon = self.weapon {
                    self.action.weapon = weapon
                    self.action.name =  self.weapon!.name
                    if weapon.weapon_range == "Melee" {
                        self.action.attrIndex = 0
                    }
                    if weapon.weapon_range == "Ranged" {
                        self.action.attrIndex = 1
                    }
                    self.damageTypeIdx = self.damageTypes.firstIndex(of: weapon.damage?.damage_type?.name ?? "") ?? 0
                    self.action.desc = weapon.desc?.joined(separator: "\n") ?? ""
                    self.damageDice = weapon.damageDice()
                }
            }
        }
    }
    
    func updateAction() {
        self.action.desc = self.desc
        self.action.isAttack = true
        self.action.damageType = self.damageTypes[self.damageTypeIdx]
    }
    
    func toHitTotal() -> String {
        
        let total = (self.action.attack_bonus) + (self.action.isProficient ? (character.model.proficiencyBonus) : 0) + character.attrBonusArray[action.attrIndex]
        
        return "\(total < 0 ? "" : "+") \(total)"
    }
    
    func damageTotal() -> String {
        
        let total = self.action.damage_bonus + (self.action.attrDamage ? character.attrBonusArray[action.attrIndex] : 0)
        
        return "\(total < 0 ? "" : "+") \(total)"
    }
}

struct AttackCreationView_Previews: PreviewProvider {
    static var previews: some View {
        AttackCreationView(action: .constant(Action()))
    }
}
